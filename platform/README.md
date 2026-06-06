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
   exists. To simulate a paid purchase before Phase 2, run in the Supabase SQL
   Editor (replace the email). This creates a test order + a time-boxed access
   row, exactly like the Mollie webhook will in Phase 2:
   ```sql
   with o as (
     insert into public.orders (user_id, course_id, mollie_payment_id, amount_cents, status)
     select p.id, c.id, 'test_' || gen_random_uuid(), c.price_cents, 'paid'
     from public.profiles p, public.courses c
     where p.email = 'you@example.com' and c.slug = 'compleet'
     returning id, user_id, course_id
   )
   insert into public.course_access (user_id, course_id, order_id, expires_at)
   select o.user_id, o.course_id, o.id,
          now() + ((select access_days from public.courses where slug = 'compleet') || ' days')::interval
   from o;
   ```

## Deploy (later)
Deploy this `platform/` directory to Vercel or Netlify, set the same env vars,
point `app.aplustheorie.nl` at it, and add the production redirect URL in Supabase.

## Next: Phase 2 — payments & access
Port the Mollie flow (`../backend`) into route handlers here, write the verified +
idempotent webhook, and grant/extend `course_access.expires_at` with the
service-role key.
