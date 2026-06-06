# A+theorie — Learning Platform (Next.js)

The authenticated learning app. The Astro marketing site (repo root) stays as-is;
this app handles accounts, practice, exams, and (later) payments — talking to the
same Supabase project. See `../docs/ARCHITECTURE.md`.

## Phase 1 (done): accounts
- Email/password **signup** with email verification
- **Login / logout** (Supabase Auth, cookie sessions via `@supabase/ssr`)
- **Protected routes** via `src/middleware.ts`
- **Dashboard** that reads live **time-boxed access** (`course_access.expires_at`)

## Run locally
```bash
cd platform
npm install
cp .env.example .env.local      # then fill in your Supabase keys
npm run dev                     # http://localhost:3000
```

### Fill in `.env.local`
From Supabase → **Project Settings → API**:
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY` (server-only; used in Phase 2)
- `NEXT_PUBLIC_SITE_URL` = `http://localhost:3000` locally, your real URL in prod

### Configure Supabase Auth (one-time, in the dashboard)
**Authentication → URL Configuration:**
- **Site URL:** `http://localhost:3000` (and your production URL later)
- **Redirect URLs:** add `http://localhost:3000/auth/confirm`
  (and `https://app.aplustheorie.nl/auth/confirm` in production)

Email confirmation is on by default — new users get a verification link that
hits `/auth/confirm`. (For quick local testing you can disable "Confirm email"
under Authentication → Providers → Email.)

## Try it
1. `/signup` → create an account → check your email → click the link.
2. `/login` → you land on `/dashboard`.
3. The dashboard shows **"Geen actieve toegang"** until a `course_access` row
   exists. To simulate paid access before Phase 2, run in the Supabase SQL
   Editor (replace the email + course):
   ```sql
   insert into public.course_access (user_id, course_id, order_id, expires_at)
   select p.id, c.id,
          gen_random_uuid(),               -- placeholder order id (FK to orders in prod)
          now() + (c.access_days || ' days')::interval
   from public.profiles p, public.courses c
   where p.email = 'you@example.com' and c.slug = 'compleet';
   ```
   > Note: `course_access.order_id` references `orders` — for a real grant create
   > an order first; this snippet is only for eyeballing the dashboard UI.

## Deploy (later)
Deploy this `platform/` directory to Vercel or Netlify, set the same env vars,
point `app.aplustheorie.nl` at it, and add the production redirect URL in Supabase.

## Next: Phase 2 — payments & access
Port the Mollie flow (`../backend`) into route handlers here, write the verified +
idempotent webhook, and grant/extend `course_access.expires_at` with the
service-role key.
