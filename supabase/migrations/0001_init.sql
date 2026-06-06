-- ============================================================================
-- A+theorie — Initial schema (Supabase / Postgres)
-- Phase 0 foundation. Paste into the Supabase SQL Editor and run.
--
-- Implements the architecture in docs/ARCHITECTURE.md:
--   • profiles tied to Supabase Auth (auth.users)
--   • TIME-BOXED access (course_access.expires_at) — the core business rule
--   • learning content (categories, questions, options, lessons) + media
--   • assessment engine (exam templates, attempts, answers) + progress
--   • Row-Level Security so users only ever see their own data
--
-- Supersedes the old backend/schema.sql.
-- ============================================================================

-- ─────────────────────────────────────────────────────────────
-- Helper: keep updated_at fresh
-- ─────────────────────────────────────────────────────────────
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- ─────────────────────────────────────────────────────────────
-- Identity: Supabase Auth owns auth.users; we mirror a profile.
-- ─────────────────────────────────────────────────────────────
create table if not exists public.profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  email       text not null,
  full_name   text,
  phone       text,
  role        text not null default 'student',   -- 'student' | 'admin'
  created_at  timestamptz not null default now()
);

-- Auto-create a profile whenever a new auth user signs up.
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, email, full_name)
  values (new.id, new.email, new.raw_user_meta_data->>'full_name')
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Admin check as SECURITY DEFINER to avoid RLS recursion on profiles.
create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.profiles where id = auth.uid() and role = 'admin'
  );
$$;

-- ─────────────────────────────────────────────────────────────
-- Catalogue
-- ─────────────────────────────────────────────────────────────
create table if not exists public.courses (
  id           uuid primary key default gen_random_uuid(),
  slug         text unique not null,
  title        text not null,
  description  text,
  price_cents  integer not null,
  access_days  integer not null,                 -- drives course_access.expires_at
  is_active    boolean not null default true,
  sort_order   integer not null default 0
);

-- ─────────────────────────────────────────────────────────────
-- Payments
-- ─────────────────────────────────────────────────────────────
create table if not exists public.orders (
  id                uuid primary key default gen_random_uuid(),
  user_id           uuid not null references public.profiles(id) on delete cascade,
  course_id         uuid not null references public.courses(id),
  mollie_payment_id text unique not null,
  amount_cents      integer not null,
  status            text not null default 'open', -- open|paid|failed|expired|canceled
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);
create index if not exists idx_orders_user   on public.orders(user_id);
create index if not exists idx_orders_mollie on public.orders(mollie_payment_id);

drop trigger if exists orders_updated_at on public.orders;
create trigger orders_updated_at
  before update on public.orders
  for each row execute function public.set_updated_at();

-- Idempotency log: a webhook replayed by Mollie must not double-grant access.
create table if not exists public.webhook_events (
  id                uuid primary key default gen_random_uuid(),
  mollie_payment_id text not null,
  received_at       timestamptz not null default now(),
  processed_at      timestamptz,
  raw               jsonb
);

-- ─────────────────────────────────────────────────────────────
-- ★ TIME-BOXED ACCESS — the core business rule ★
-- One row per (user, course). Renewal EXTENDS expires_at.
-- ─────────────────────────────────────────────────────────────
create table if not exists public.course_access (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references public.profiles(id) on delete cascade,
  course_id   uuid not null references public.courses(id),
  order_id    uuid not null references public.orders(id),
  starts_at   timestamptz not null default now(),
  expires_at  timestamptz not null,             -- access is valid only until here
  created_at  timestamptz not null default now(),
  unique (user_id, course_id)
);
create index if not exists idx_access_user    on public.course_access(user_id);
create index if not exists idx_access_expires on public.course_access(expires_at);

-- The single source of truth for "does this user have valid access right now".
-- SECURITY DEFINER so content policies can call it without extra grants.
create or replace function public.has_active_access()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.course_access
    where user_id = auth.uid()
      and expires_at > now()                     -- ← time-box enforced live
  );
$$;

-- ─────────────────────────────────────────────────────────────
-- Media: every image/video is a first-class asset.
-- ─────────────────────────────────────────────────────────────
create table if not exists public.media_assets (
  id            uuid primary key default gen_random_uuid(),
  kind          text not null,                  -- 'image' | 'video'
  provider      text not null,                  -- 'supabase' | 'r2' | 'mux' | 'cf_stream'
  storage_key   text,                           -- object key (images)
  playback_id   text,                           -- Mux/Stream id (video)
  duration_ms   integer,
  width         integer,
  height        integer,
  alt_text      text,
  created_at    timestamptz not null default now()
);

-- ─────────────────────────────────────────────────────────────
-- Learning content
-- ─────────────────────────────────────────────────────────────
create table if not exists public.categories (
  id          uuid primary key default gen_random_uuid(),
  slug        text unique not null,
  name        text not null,
  kind        text not null,                    -- 'knowledge' | 'insight' | 'hazard'
  sort_order  integer not null default 0
);

create table if not exists public.questions (
  id            uuid primary key default gen_random_uuid(),
  category_id   uuid not null references public.categories(id),
  type          text not null,                  -- 'single' | 'multi' | 'truefalse' | 'hazard'
  stem          text not null,
  media_id      uuid references public.media_assets(id),
  explanation   text,
  explanation_media_id uuid references public.media_assets(id),
  difficulty    smallint not null default 2,    -- 1..3
  hazard_config jsonb,                          -- for type='hazard'
  status        text not null default 'draft',  -- 'draft' | 'published' | 'retired'
  created_at    timestamptz not null default now()
);
create index if not exists idx_questions_cat on public.questions(category_id, status);

create table if not exists public.question_options (
  id          uuid primary key default gen_random_uuid(),
  question_id uuid not null references public.questions(id) on delete cascade,
  label       text not null,
  media_id    uuid references public.media_assets(id),
  is_correct  boolean not null default false,
  sort_order  integer not null default 0,
  feedback    text
);
create index if not exists idx_options_question on public.question_options(question_id);

create table if not exists public.lessons (
  id          uuid primary key default gen_random_uuid(),
  course_id   uuid references public.courses(id),
  category_id uuid references public.categories(id),
  title       text not null,
  body        text,
  sort_order  integer not null default 0,
  status      text not null default 'draft'
);

create table if not exists public.lesson_media (
  lesson_id   uuid not null references public.lessons(id) on delete cascade,
  media_id    uuid not null references public.media_assets(id),
  sort_order  integer not null default 0,
  primary key (lesson_id, media_id)
);

-- ─────────────────────────────────────────────────────────────
-- Assessment engine
-- ─────────────────────────────────────────────────────────────
create table if not exists public.exam_templates (
  id             uuid primary key default gen_random_uuid(),
  title          text not null,
  kind           text not null,                 -- 'mock' | 'practice'
  question_count integer not null,
  pass_threshold integer not null,
  time_limit_s   integer,
  category_mix   jsonb
);

create table if not exists public.exam_attempts (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references public.profiles(id) on delete cascade,
  template_id   uuid references public.exam_templates(id),
  kind          text not null,                  -- 'mock' | 'practice' | 'weakspots'
  started_at    timestamptz not null default now(),
  submitted_at  timestamptz,
  score         integer,
  passed        boolean
);
create index if not exists idx_attempts_user on public.exam_attempts(user_id, started_at desc);

create table if not exists public.attempt_answers (
  id            uuid primary key default gen_random_uuid(),
  attempt_id    uuid not null references public.exam_attempts(id) on delete cascade,
  question_id   uuid not null references public.questions(id),
  response      jsonb,
  is_correct    boolean,
  time_ms       integer,
  answered_at   timestamptz not null default now()
);
create index if not exists idx_answers_attempt on public.attempt_answers(attempt_id);

-- Per-user mastery → powers "weak spots" + spaced repetition.
create table if not exists public.user_question_stats (
  user_id       uuid not null references public.profiles(id) on delete cascade,
  question_id   uuid not null references public.questions(id),
  times_seen    integer not null default 0,
  times_correct integer not null default 0,
  last_seen_at  timestamptz,
  next_due_at   timestamptz,
  ease          real not null default 2.5,
  primary key (user_id, question_id)
);

-- ============================================================================
-- ROW-LEVEL SECURITY
-- ============================================================================
alter table public.profiles            enable row level security;
alter table public.courses             enable row level security;
alter table public.orders              enable row level security;
alter table public.course_access       enable row level security;
alter table public.media_assets        enable row level security;
alter table public.categories          enable row level security;
alter table public.questions           enable row level security;
alter table public.question_options    enable row level security;
alter table public.lessons             enable row level security;
alter table public.lesson_media        enable row level security;
alter table public.exam_templates      enable row level security;
alter table public.exam_attempts       enable row level security;
alter table public.attempt_answers     enable row level security;
alter table public.user_question_stats enable row level security;

-- Note: the service_role key (server-side: Mollie webhook, admin jobs) bypasses
-- RLS entirely, so we only write policies for the user/anon facing access here.

-- Profiles: a user reads/updates only their own; admins see all.
drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own" on public.profiles
  for select using (id = auth.uid() or public.is_admin());
drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own" on public.profiles
  for update using (id = auth.uid());

-- Courses: public catalogue (needed on the marketing/pricing pages).
drop policy if exists "courses_public_read" on public.courses;
create policy "courses_public_read" on public.courses
  for select using (is_active or public.is_admin());

-- Orders & access: a user sees only their own (writes happen via service role).
drop policy if exists "orders_select_own" on public.orders;
create policy "orders_select_own" on public.orders
  for select using (user_id = auth.uid() or public.is_admin());
drop policy if exists "access_select_own" on public.course_access;
create policy "access_select_own" on public.course_access
  for select using (user_id = auth.uid() or public.is_admin());

-- Categories: readable by everyone (used for catalogue/preview).
drop policy if exists "categories_read" on public.categories;
create policy "categories_read" on public.categories
  for select using (true);

-- Learning content: readable only with valid, unexpired access (or admin).
drop policy if exists "questions_read_with_access" on public.questions;
create policy "questions_read_with_access" on public.questions
  for select using (
    public.is_admin()
    or (status = 'published' and public.has_active_access())
  );

drop policy if exists "options_read_with_access" on public.question_options;
create policy "options_read_with_access" on public.question_options
  for select using (
    public.is_admin()
    or (public.has_active_access()
        and exists (select 1 from public.questions q
                    where q.id = question_id and q.status = 'published'))
  );

drop policy if exists "lessons_read_with_access" on public.lessons;
create policy "lessons_read_with_access" on public.lessons
  for select using (
    public.is_admin()
    or (status = 'published' and public.has_active_access())
  );

drop policy if exists "lesson_media_read_with_access" on public.lesson_media;
create policy "lesson_media_read_with_access" on public.lesson_media
  for select using (public.is_admin() or public.has_active_access());

drop policy if exists "media_read_with_access" on public.media_assets;
create policy "media_read_with_access" on public.media_assets
  for select using (public.is_admin() or public.has_active_access());

drop policy if exists "exam_templates_read_with_access" on public.exam_templates;
create policy "exam_templates_read_with_access" on public.exam_templates
  for select using (public.is_admin() or public.has_active_access());

-- A user's own attempts / answers / progress: full CRUD on their own rows.
drop policy if exists "attempts_own" on public.exam_attempts;
create policy "attempts_own" on public.exam_attempts
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists "answers_own" on public.attempt_answers;
create policy "answers_own" on public.attempt_answers
  for all using (
    exists (select 1 from public.exam_attempts a
            where a.id = attempt_id and a.user_id = auth.uid())
  ) with check (
    exists (select 1 from public.exam_attempts a
            where a.id = attempt_id and a.user_id = auth.uid())
  );

drop policy if exists "stats_own" on public.user_question_stats;
create policy "stats_own" on public.user_question_stats
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

-- ============================================================================
-- SEED: categories (slugs match content/questions.seed.json) + courses
-- ============================================================================
insert into public.categories (slug, name, kind, sort_order) values
  ('verkeersregels',     'Verkeersregels',          'knowledge', 1),
  ('verkeersinzicht',    'Verkeersinzicht',         'insight',   2),
  ('gevaarherkenning',   'Gevaarherkenning',        'hazard',    3),
  ('voertuig-en-milieu', 'Voertuigkennis & Milieu', 'knowledge', 4)
on conflict (slug) do nothing;

-- Placeholder packages — UPDATE prices/durations to your real offer.
insert into public.courses (slug, title, description, price_cents, access_days, sort_order) values
  ('basis',    'Basis',    'Toegang tot alle oefenvragen en proefexamens.',        2495, 30, 1),
  ('compleet', 'Compleet', 'Alle oefenvragen, proefexamens en gevaarherkenning.',  3995, 90, 2)
on conflict (slug) do nothing;

-- Done. Next: run supabase/seed_questions.sql to load the 100 questions.
