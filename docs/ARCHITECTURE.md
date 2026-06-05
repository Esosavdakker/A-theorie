# A+theorie — Platform Architecture

> **Status:** Proposed architecture for turning A+theorie from a marketing site into
> the full learning system: **sign up → pay → time‑boxed access → log in anytime →
> learn & practice (with image and video questions) while access is valid.**
>
> This document is the blueprint. It is written to be handed to a developer and
> executed phase by phase. It explicitly calls out what already exists in the repo
> and what must change.

---

## 1. What we are building

A commercial CBR theory‑exam learning platform with a paid, time‑limited access model.

The end‑to‑end user journey:

1. **Sign up** — create an account (email + password, email verification).
2. **Choose a package & pay** — iDEAL via Mollie (Basis = 30 days, Compleet = 90 days).
3. **Get access for a fixed duration** — access is granted *until a date*, not forever.
4. **Log in anytime** — return as often as they like while access is valid.
5. **Learn & practice** — read lessons, practice by category, take CBR‑style mock
   exams, and train **gevaarherkenning (hazard perception) with video clips**.
   Questions and lessons can contain **pictures and videos**.
6. **Renewal / expiry** — when access expires, the learning area locks and the user
   is prompted to renew (which extends, not replaces, their time).

The central business rule that does **not** exist in the code today and must be the
spine of the system: **access is valid only until `expires_at`, and every protected
action re‑checks `now() < expires_at`.**

---

## 2. Current state of the repo (honest gap analysis)

| Capability | Today | Needed |
|---|---|---|
| Marketing site (Astro) | ✅ Polished, config‑driven | Keep as the funnel |
| Contact form (Netlify fn + Resend) | ✅ Works | Keep |
| DB tables: `users`, `courses`, `orders`, `course_access` | ✅ Exist | Re‑base on Supabase Auth |
| Mollie create‑payment + webhook | 🟡 Works, but webhook unverified | Verify + idempotent |
| **Authentication (signup/login/session)** | ❌ None | **Build (Supabase Auth)** |
| **Time‑boxed access (`expires_at`)** | ❌ `course_access` grants forever | **Build — the core rule** |
| **Learning content (questions, lessons, exams)** | ❌ None | **Build** |
| **Image / video questions & lessons** | ❌ None | **Build (media pipeline)** |
| Progress tracking / weak‑spots | ❌ None | Build |
| Two front‑ends joined | ❌ Astro site and React/Express snippets are separate | Unify |
| Security: RLS, signed media, no `userId` in URL | ❌ `GET /access/:userId/:courseId` is open | Build |

**Conclusion:** the repo is a *payment‑and‑access skeleton*. The three things that make
it the product — **accounts, time‑boxed access, and the learning engine (with media)** —
are not built, and the two halves aren't connected.

---

## 3. Recommended stack (built to scale)

Optimised for: a small team, a Dutch‑market business, heavy read traffic on a question
bank, **protected video/image delivery**, and room to grow.

| Layer | Choice | Why |
|---|---|---|
| **App framework** | **Next.js (App Router, TypeScript)** | One codebase for marketing + authed app, SSR for SEO on marketing and protected server components for the app, huge hiring pool, scales horizontally (stateless). |
| **Hosting** | **Vercel** (or Netlify — both fine) | Edge network, autoscaling, zero‑config Next.js. |
| **Identity** | **Supabase Auth** | Email/password, verification, password reset, OAuth later. Issues JWTs that drive Row‑Level Security. Don't hand‑roll auth. |
| **Database** | **Supabase Postgres** | Already chosen. Relational fits exams/attempts/access cleanly. RLS enforces ownership in the DB itself. |
| **Connection pooling** | **Supabase Pooler (PgBouncer)** | Serverless functions open many short connections — pool them or Postgres falls over under load. |
| **Images** | **Supabase Storage** (or Cloudflare R2 + Images) behind **signed URLs** | Paid content must not be hotlinkable. Served via CDN. |
| **Video (hazard clips, lessons)** | **Mux** or **Cloudflare Stream** | Adaptive bitrate (HLS), per‑view **signed playback tokens**, thumbnails, global CDN. Do **not** serve MP4s from app storage at scale. |
| **Payments** | **Mollie (iDEAL)** | Already integrated; correct for NL. |
| **Transactional email** | **Resend** | Already used by the contact form. Reuse for verification/receipts. |
| **Caching** | CDN edge cache for the (read‑heavy, rarely‑changing) question bank; optional **Redis (Upstash)** later for rate limiting & sessions at scale | Question bank is read‑mostly — cache aggressively. |
| **Background jobs** | Supabase Edge Functions / Vercel Cron | Expiry sweeps, reminder emails, analytics rollups. |

### Marketing site decision

Fold the existing Astro marketing pages into the Next.js app (marketing on the public
routes, the learning app behind auth) **or** keep Astro for marketing and run the app on
`app.aplustheorie.nl`. Recommendation for a *scaling* system: **single Next.js app**, so
session, brand tokens, and deploy pipeline are shared. Port `src/styles/tokens.css` and
`site.config.js` over verbatim — they're already framework‑agnostic.

> **Migration note:** Supabase is the keeper from the current `backend/`. The standalone
> Express server can be retired — its three endpoints become Next.js route handlers /
> Supabase Edge Functions that run with the user's session, so the open
> `GET /access/:userId/:courseId` (anyone can query anyone) goes away.

---

## 4. High‑level architecture

```
                        ┌──────────────────────────────────────────┐
                        │              Browser (user)                │
                        │  marketing pages · auth · dashboard ·      │
                        │  lessons · practice · mock exam · hazard   │
                        └───────────────┬───────────────┬───────────┘
                                        │ HTTPS          │ signed media URLs
                                        ▼                ▼
                 ┌──────────────────────────────┐   ┌──────────────────────┐
                 │   Next.js (Vercel/Netlify)    │   │  Mux / Cloudflare      │
                 │  • SSR marketing (SEO)        │   │  Stream (video CDN)    │
                 │  • Auth‑guarded app routes    │   │  • signed playback     │
                 │  • API route handlers:        │   └──────────────────────┘
                 │    /api/checkout              │   ┌──────────────────────┐
                 │    /api/webhooks/mollie       │   │ Supabase Storage / R2 │
                 │    /api/exam/*                │   │  (images, signed URL)  │
                 └───────┬───────────────┬───────┘   └──────────────────────┘
                         │ service role  │ user JWT (RLS)
                         ▼               ▼
                 ┌────────────────────────────────────────────┐
                 │              Supabase                        │
                 │  Auth · Postgres (+RLS) · Storage · Edge Fns │
                 └───────────────┬──────────────────────────────┘
                                 │  webhook (payment paid)
                                 ▼
                            ┌──────────┐
                            │  Mollie  │  iDEAL checkout
                            └──────────┘
```

Key principle: **two trust levels.**
- **User‑scoped** requests carry the Supabase JWT; Postgres RLS guarantees a user only
  ever sees their own profile, access, attempts, and progress.
- **Service‑role** code (the Mollie webhook, expiry jobs) runs server‑side only, never in
  the browser, and is the *only* thing allowed to grant/extend access.

---

## 5. Data model

All money stored as integer **cents**. All access decisions key off `expires_at`.

```sql
-- ─────────────────────────────────────────────────────────────
-- Identity: Supabase Auth owns auth.users. We mirror a profile.
-- ─────────────────────────────────────────────────────────────
create table profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  email       text not null,
  full_name   text,
  phone       text,
  role        text not null default 'student',   -- 'student' | 'admin'
  created_at  timestamptz not null default now()
);

-- ─────────────────────────────────────────────────────────────
-- Catalogue
-- ─────────────────────────────────────────────────────────────
create table courses (
  id           uuid primary key default gen_random_uuid(),
  slug         text unique not null,             -- 'basis' | 'compleet'
  title        text not null,
  description  text,
  price_cents  integer not null,
  access_days  integer not null,                 -- 30, 90 → drives expires_at
  is_active    boolean not null default true,
  sort_order   integer not null default 0
);

-- ─────────────────────────────────────────────────────────────
-- Payments
-- ─────────────────────────────────────────────────────────────
create table orders (
  id                uuid primary key default gen_random_uuid(),
  user_id           uuid not null references profiles(id) on delete cascade,
  course_id         uuid not null references courses(id),
  mollie_payment_id text unique not null,
  amount_cents      integer not null,
  status            text not null default 'open', -- open|paid|failed|expired|canceled
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);

-- Idempotency log so a webhook replayed by Mollie can't double‑grant.
create table webhook_events (
  id                uuid primary key default gen_random_uuid(),
  mollie_payment_id text not null,
  received_at       timestamptz not null default now(),
  processed_at      timestamptz,
  raw               jsonb
);

-- ─────────────────────────────────────────────────────────────
-- ★ TIME‑BOXED ACCESS — the core business rule ★
-- One row per (user, course). Renewal EXTENDS expires_at.
-- ─────────────────────────────────────────────────────────────
create table course_access (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references profiles(id) on delete cascade,
  course_id   uuid not null references courses(id),
  order_id    uuid not null references orders(id),
  starts_at   timestamptz not null default now(),
  expires_at  timestamptz not null,             -- ← access is valid only until here
  created_at  timestamptz not null default now(),
  unique (user_id, course_id)
);
create index on course_access (user_id);
create index on course_access (expires_at);

-- ─────────────────────────────────────────────────────────────
-- Media: every image/video is a first‑class asset, referenced by
-- questions, options, and lessons. Never store raw URLs inline.
-- ─────────────────────────────────────────────────────────────
create table media_assets (
  id            uuid primary key default gen_random_uuid(),
  kind          text not null,                  -- 'image' | 'video'
  provider      text not null,                  -- 'supabase' | 'r2' | 'mux' | 'cf_stream'
  storage_key   text,                           -- object key (images)
  playback_id   text,                           -- Mux/Stream id (video)
  duration_ms   integer,                        -- video length
  width         integer,
  height        integer,
  alt_text      text,                           -- accessibility (required for images)
  created_at    timestamptz not null default now()
);

-- ─────────────────────────────────────────────────────────────
-- Learning content
-- ─────────────────────────────────────────────────────────────
create table categories (
  id          uuid primary key default gen_random_uuid(),
  slug        text unique not null,
  name        text not null,                    -- 'Verkeersregels', 'Verkeersinzicht', 'Gevaarherkenning'
  kind        text not null,                    -- 'knowledge' | 'insight' | 'hazard'
  sort_order  integer not null default 0
);

create table questions (
  id            uuid primary key default gen_random_uuid(),
  category_id   uuid not null references categories(id),
  type          text not null,                  -- 'single' | 'multi' | 'truefalse' | 'hazard'
  stem          text not null,                  -- the question text
  media_id      uuid references media_assets(id), -- optional picture/video on the question
  explanation   text,                           -- shown after answering
  explanation_media_id uuid references media_assets(id),
  difficulty    smallint not null default 2,    -- 1..3
  hazard_config jsonb,                           -- for type='hazard': danger window, scoring zones
  status        text not null default 'draft',  -- 'draft' | 'published' | 'retired'
  created_at    timestamptz not null default now()
);
create index on questions (category_id, status);

create table question_options (
  id          uuid primary key default gen_random_uuid(),
  question_id uuid not null references questions(id) on delete cascade,
  label       text not null,
  media_id    uuid references media_assets(id), -- options can be images too
  is_correct  boolean not null default false,
  sort_order  integer not null default 0,
  feedback    text                              -- optional per‑option explanation
);
create index on question_options (question_id);

create table lessons (
  id          uuid primary key default gen_random_uuid(),
  course_id   uuid references courses(id),
  category_id uuid references categories(id),
  title       text not null,
  body        text,                             -- rich text / MDX
  sort_order  integer not null default 0,
  status      text not null default 'draft'
);

create table lesson_media (                     -- a lesson can embed many images/videos
  lesson_id   uuid not null references lessons(id) on delete cascade,
  media_id    uuid not null references media_assets(id),
  sort_order  integer not null default 0,
  primary key (lesson_id, media_id)
);

-- ─────────────────────────────────────────────────────────────
-- Assessment engine
-- ─────────────────────────────────────────────────────────────
create table exam_templates (
  id            uuid primary key default gen_random_uuid(),
  title         text not null,
  kind          text not null,                  -- 'mock' | 'practice'
  question_count integer not null,              -- CBR auto mock = 65
  pass_threshold integer not null,              -- CBR auto = 44
  time_limit_s  integer,
  category_mix  jsonb                            -- how many from each category
);

create table exam_attempts (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references profiles(id) on delete cascade,
  template_id   uuid references exam_templates(id),
  kind          text not null,                  -- 'mock' | 'practice' | 'weakspots'
  started_at    timestamptz not null default now(),
  submitted_at  timestamptz,
  score         integer,
  passed        boolean
);
create index on exam_attempts (user_id, started_at desc);

create table attempt_answers (
  id            uuid primary key default gen_random_uuid(),
  attempt_id    uuid not null references exam_attempts(id) on delete cascade,
  question_id   uuid not null references questions(id),
  response      jsonb,                           -- selected option ids OR hazard click {t_ms}
  is_correct    boolean,
  time_ms       integer,
  answered_at   timestamptz not null default now()
);
create index on attempt_answers (attempt_id);

-- ─────────────────────────────────────────────────────────────
-- Per‑user mastery → powers "weak spots" + spaced repetition
-- ─────────────────────────────────────────────────────────────
create table user_question_stats (
  user_id       uuid not null references profiles(id) on delete cascade,
  question_id   uuid not null references questions(id),
  times_seen    integer not null default 0,
  times_correct integer not null default 0,
  last_seen_at  timestamptz,
  next_due_at   timestamptz,                     -- spaced‑repetition schedule
  ease          real not null default 2.5,
  primary key (user_id, question_id)
);
```

### What changed vs. the existing `backend/schema.sql`
- `users` → **`profiles`** keyed to `auth.users` (Supabase Auth owns identity).
- `course_access` gains **`expires_at`** + `starts_at` (the whole point).
- `courses` gains **`access_days`** and prices move to **cents**.
- Added: `webhook_events` (idempotency), all of media/content/assessment/progress.

---

## 6. Authentication & access control

**Auth = Supabase Auth.** Signup, login, email verification, and password reset are
handled for you. A new `auth.users` row triggers a `profiles` row (via a Postgres
trigger). The browser holds a short‑lived JWT; server components/route handlers read it.

**Authorization = Postgres Row‑Level Security**, so the rules live in the database and
cannot be bypassed by a tampered request.

```sql
alter table profiles            enable row level security;
alter table course_access       enable row level security;
alter table exam_attempts        enable row level security;
alter table attempt_answers      enable row level security;
alter table user_question_stats  enable row level security;

-- A user sees only their own rows.
create policy "own profile"  on profiles
  for select using (id = auth.uid());
create policy "own access"   on course_access
  for select using (user_id = auth.uid());
create policy "own attempts" on exam_attempts
  for all using (user_id = auth.uid());

-- The single source of truth for "is access valid right now".
create or replace function has_valid_access(p_course uuid)
returns boolean language sql stable as $$
  select exists (
    select 1 from course_access
    where user_id = auth.uid()
      and course_id = p_course
      and expires_at > now()            -- ← time‑box enforced here
  );
$$;

-- Learning content is readable only with valid, unexpired access.
alter table questions enable row level security;
create policy "questions need valid access" on questions
  for select using (
    status = 'published'
    and has_valid_access('<theory-course-id>')   -- or join via category→course
  );
-- (same pattern for question_options, lessons, lesson_media)
```

Because content reads themselves are gated by `has_valid_access()`, **expiry is enforced
everywhere automatically** — the day `expires_at` passes, every question/lesson query
returns nothing and the UI shows the "renew" state. No cron job is required to *revoke*;
expiry is computed live. (A nightly job only sends "your access expires in 3 days" emails.)

---

## 7. Payments & the access lifecycle

Flow:

1. Logged‑in user clicks **Buy** → `POST /api/checkout { courseId }`.
   Server creates a Mollie payment (amount from `courses.price_cents`), records an
   `orders` row (`status='open'`), returns the Mollie `checkoutUrl`.
2. User pays via iDEAL → Mollie redirects them back to `/betaling/retour`.
3. Mollie calls **`POST /api/webhooks/mollie`** (server‑to‑server, the source of truth):
   - **Verify** the payment by re‑fetching it from Mollie by id (never trust the body).
   - **Idempotency:** insert into `webhook_events`; if already processed, return `200`.
   - On `paid`: update the order, then **grant or extend** access:

```sql
-- Grant on first purchase; extend on renewal (from the later of now / current expiry).
insert into course_access (user_id, course_id, order_id, starts_at, expires_at)
values (
  :user_id, :course_id, :order_id, now(),
  now() + make_interval(days => (select access_days from courses where id = :course_id))
)
on conflict (user_id, course_id) do update
set expires_at = greatest(course_access.expires_at, now())
               + make_interval(days => (select access_days from courses where id = :course_id)),
    order_id   = excluded.order_id;
```

4. `/betaling/retour` polls `has_valid_access()` (server‑side, session‑scoped) and, once
   true, sends the user into the dashboard.

**Hardening vs. the current code:** verify the webhook, make it idempotent, and remove the
public `GET /access/:userId/:courseId` — access is read through the session + RLS, so a
user can never query someone else's access.

---

## 8. Media architecture (images **and** video)

This is first‑class because questions, answer options, lessons, and especially
**gevaarherkenning** rely on it. Paid media must not be freely hotlinkable.

### Images (question diagrams, traffic situations, option images)
- Stored in **Supabase Storage** (or Cloudflare R2) in a **private** bucket.
- Delivered through **short‑lived signed URLs** minted server‑side *only after*
  `has_valid_access()` passes. Served via CDN; cache the signed responses briefly.
- Every image asset carries `alt_text` (accessibility + SEO on public preview images).
- Originals uploaded by admins; generate responsive sizes (e.g. an upload‑triggered
  Edge Function) so mobile users don't pull full‑res.

### Video (hazard‑perception clips, lesson videos)
- **Do not serve MP4s from app storage.** Use **Mux** or **Cloudflare Stream**:
  - Adaptive bitrate (HLS) → works on every connection/device.
  - **Signed playback tokens (JWT)** with short TTL, minted server‑side per view after
    the access check → paid clips can't be shared by copying a URL.
  - Automatic thumbnails/posters, and per‑view analytics.
- `media_assets.playback_id` stores the Mux/Stream id; the app exchanges it for a signed
  playback token at watch time.

### Hazard‑perception specifics
`questions.type = 'hazard'` with `hazard_config` (JSONB), e.g.:

```json
{
  "playback_id": "abc123",
  "danger_window_ms": { "start": 4200, "end": 6800 },
  "scoring": [
    { "from": 4200, "to": 5200, "points": 100 },
    { "from": 5201, "to": 6800, "points": 50 }
  ]
}
```

The client records the timestamp of the user's "danger!" click; the server scores it
against the window. The clip plays once, full‑screen, no scrubbing — mirroring the CBR.

**Upload pipeline (admin):** admin uploads → asset lands in Storage/Mux → `media_assets`
row created → attached to a question/lesson. Keep an authoring/admin surface (even a
simple internal tool or Supabase Studio + a thin admin app) — content operations are the
ongoing cost of this business.

---

## 9. The learning engine

Built on the schema above:

- **Lessons** — rich text + embedded images/videos, grouped by category, gated by access.
- **Practice by category** — pull `published` questions from a category; immediate
  feedback + `explanation`; updates `user_question_stats`.
- **Mock exam** — `exam_templates` defines the CBR shape (e.g. 65 questions, pass at 44,
  timed, category mix). Generates an `exam_attempts` + `attempt_answers`, scores at submit.
- **Weak‑spots / spaced repetition** — `user_question_stats.next_due_at` + `ease` schedule
  questions the user gets wrong more often. This is the retention engine and the main
  justification for the price.
- **Progress dashboard** — readiness per category, mock‑exam pass rate over time, "access
  valid until {date}" banner. Fulfils the *"persoonlijke voortgangsrapportage"* promise.

---

## 10. API surface (Next.js route handlers / Edge Functions)

| Route | Auth | Purpose |
|---|---|---|
| `POST /api/checkout` | user | Create Mollie payment + `orders` row, return checkout URL |
| `POST /api/webhooks/mollie` | service (verified) | Confirm payment, grant/extend `course_access` |
| `GET  /api/access` | user | Current entitlement(s) + `expires_at` (session‑scoped, no ids in URL) |
| `GET  /api/lessons` / `/api/lessons/:id` | user + valid access | Lesson content + signed media |
| `GET  /api/practice?category=` | user + valid access | A practice question set |
| `POST /api/exam/start` | user + valid access | Create a mock/practice attempt |
| `POST /api/exam/:attempt/answer` | user + valid access | Record an answer (incl. hazard click) |
| `POST /api/exam/:attempt/submit` | user + valid access | Score + persist result |
| `GET  /api/media/:assetId/url` | user + valid access | Mint a short‑lived signed image/video URL |
| `POST /api/admin/*` | admin | Author content, upload media |

Auth/signup/reset themselves are handled by the Supabase Auth client SDK — no custom
endpoints needed.

---

## 11. Security checklist

- ✅ Supabase Auth for identity; **RLS on every user‑owned table**.
- ✅ Access read through the session — **drop `GET /access/:userId/:courseId`**.
- ✅ **Webhook verified** (re‑fetch from Mollie) + **idempotent** (`webhook_events`).
- ✅ Only **service‑role server code** can grant/extend access; the service key never
  touches the browser.
- ✅ Paid media behind **short‑lived signed URLs / playback tokens**; private buckets.
- ✅ Rate limiting on auth + checkout + contact (reuse the existing limiter pattern,
  move to Upstash Redis when multi‑instance).
- ✅ Input validation server‑side (the contact function is a good template).
- ✅ Secrets in env (Mollie key, Supabase service key, Mux signing key) — never committed.
- ✅ GDPR/AVG: cookie banner already present; add a data‑export/delete path for profiles.

---

## 12. Scaling notes

- **Stateless app tier** → scales horizontally on Vercel/Netlify automatically.
- **Connection pooling** is mandatory in front of Postgres for serverless (Supabase Pooler).
- **Question bank is read‑mostly** → cache hard at the CDN/edge; bust on publish. This is
  the cheapest big win as traffic grows.
- **Video offloaded** to Mux/Stream → app servers never push large media; bandwidth scales
  with the video CDN, not your origin.
- **Heavy per‑user writes** are `attempt_answers` — partition/rollup into analytics tables
  later; add read replicas for reporting when needed.
- **Background work** (expiry reminders, analytics rollups) on Vercel Cron / Supabase Edge
  Functions so it doesn't block request paths.

---

## 13. Build roadmap

**Phase 0 — Foundation**
Stand up Next.js (port `tokens.css` + `site.config.js`), wire Supabase, run the new schema,
enable RLS, retire the Express server.

**Phase 1 — Accounts**
Supabase Auth: signup, email verification, login, logout, password reset. `profiles`
trigger. Gated `/dashboard` shell.

**Phase 2 — Pay & time‑boxed access** ← *the spine of your flow*
`/api/checkout`, verified+idempotent Mollie webhook, `course_access.expires_at`, renewal
logic, "valid until {date}" banner, expiry lock state.

**Phase 3 — Media pipeline**
Private image storage + signed URLs; Mux/Stream integration + signed playback; admin
upload → `media_assets`.

**Phase 4 — Learning engine**
Lessons, category practice, `user_question_stats`, progress dashboard.

**Phase 5 — Exams & hazard perception**
`exam_templates`, mock‑exam flow (65/44, timed), hazard‑clip player + scoring, weak‑spots /
spaced repetition.

**Phase 6 — Harden & polish**
Rate limiting at scale, CDN caching of the bank, analytics, GDPR export/delete, admin UX.

**Phase 7 — Content**
The ongoing work: a licensed or originally‑authored question/clip bank kept current with
CBR rules. *This is the real moat and the real cost — secure the content source before
Phase 4.*

---

## 14. Open decisions (need a business answer)

1. **Content/licensing** — license a CBR‑aligned question + hazard‑clip bank, or author
   your own? (Legal: you cannot copy CBR's official items.) **Blocks Phase 4.**
2. **Video host** — Mux vs. Cloudflare Stream (cost vs. features).
3. **Access semantics** — does buying "Compleet" while "Basis" is active *extend* or
   *replace*? (Schema assumes per‑course rows; decide cross‑package upgrade rules.)
4. **Marketing site** — fold Astro into Next now, or keep separate on a subdomain?
5. **Auth methods** — email/password only at launch, or also Google/Apple sign‑in?
6. **Refunds / chargebacks** — should a refund immediately revoke access (set
   `expires_at = now()`)?

---

*This document describes the target architecture. Implementation should proceed phase by
phase; each phase is independently shippable.*
