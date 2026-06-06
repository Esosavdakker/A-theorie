# Supabase setup — A+theorie

Phase 0 database for the learning platform. See `docs/ARCHITECTURE.md` for the
full design.

## Files
- `migrations/0001_init.sql` — schema, Row-Level Security, helper functions,
  the auth→profiles trigger, and seed categories + placeholder courses.
- `seed_questions.sql` — the 100 theory questions + answer options
  (generated from `content/questions.seed.json`).

## How to run (first time, on a fresh project)

1. In the Supabase dashboard → **SQL Editor**.
2. Paste the contents of **`migrations/0001_init.sql`** → **Run**.
3. Paste the contents of **`seed_questions.sql`** → **Run**.
4. Verify: **Table Editor** should show `categories` (4 rows), `courses`
   (2 rows), `questions` (100 rows), `question_options` (~300 rows).

> Re-running `seed_questions.sql` will insert the questions again (duplicates).
> Only run it once, or `truncate public.question_options, public.questions;`
> first.

## Make yourself an admin
After you've signed up through the app (so an `auth.users` + `profiles` row
exists), run in the SQL Editor:

```sql
update public.profiles set role = 'admin' where email = 'you@example.com';
```

Admins bypass the access checks in RLS (see `is_admin()`), which is useful for
content management before the admin UI exists.

## Key things to know
- **Time-boxed access** lives in `course_access.expires_at`. The function
  `has_active_access()` checks `expires_at > now()` live, so expiry is enforced
  automatically on every content read — no revoke job needed.
- **RLS is on.** The browser (anon/auth key) only ever sees the current user's
  own rows. Granting/extending access must be done server-side with the
  **service_role** key (the Mollie webhook), which bypasses RLS.
- **Never expose the service_role key in the browser.** Keep it in server-side
  env only.

## Connection details for the app (Phase 1+)
From Supabase → Project Settings → API:
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY` (browser / public)
- `SUPABASE_SERVICE_ROLE_KEY` (server only — webhook, admin jobs)
