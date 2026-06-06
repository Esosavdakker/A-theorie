# A+theorie — Integration & Handoff

Coordination doc for the two work streams:

- **Front-end** (login UI and other pages) — owned by the main-repo developer.
- **Payments + content/learning back-end** (Mollie, the 100 questions, exam
  engine) — owned by the A+theorie agent stream.

This document states exactly what each side needs from the other so the payment
work can be merged and a concrete plan/agreement can be made with Alex.

---

## 1. What is already built (current status)

All on the fork `yakubufahad84-web/a-theorie`, branch
`claude/create-aplus-theorie-site-i8ucE`:

| Area | Status | Where |
|---|---|---|
| Database schema (Supabase) + Row-Level Security | ✅ Done, deployed | `supabase/migrations/0001_init.sql` |
| **Time-boxed access** model (`course_access.expires_at`) | ✅ Done | same |
| 100 original Dutch exam questions + options | ✅ Done, in DB | `content/questions.seed.json`, `supabase/seed_questions.sql` |
| Auth app: signup, email verify, login, protected dashboard | ✅ Done, live on Vercel | `platform/` (Next.js) |
| Dashboard reads live access status | ✅ Working | `platform/src/app/dashboard` |
| Mollie payments | ⏳ To build (this stream) | — |
| Practice / mock-exam / hazard UI | ⏳ To scope | — |

> Note on overlap: `platform/` already contains a working **login + dashboard**
> wired to Supabase Auth. The front-end dev building a "login page" should
> decide whether to **build on top of `platform/`** (recommended — reuse the
> working auth wiring and just restyle) or replace those pages. See §4.

---

## 2. Mollie payments — the contract

### What I need FROM the front-end / Alex
1. **Mollie API keys** — a **test** key (`test_…`) to build against now, and the
   **live** key (`live_…`) for launch. Provided as environment variables, never
   committed to the repo.
2. **Mollie account ready for the methods you want** — at minimum **iDEAL**
   enabled; organisation/website profile verified (required before live).
3. **Final packages & prices** — confirm or replace the current placeholders
   in the `courses` table. For each package I need: name, price (€), and access
   **duration in days**. Current placeholders:
   - `basis` — €24,95 — 30 days
   - `compleet` — €39,95 — 90 days
4. **The app's public URL** (Vercel) so Mollie can reach the webhook and send
   users back after payment. Webhook must be a stable public HTTPS URL.
5. **Two front-end pages** (UI only — I provide the logic to call):
   - a **pricing / "kies je pakket"** page with a buy button per package, and
   - a **payment-return page** (e.g. `/betaling/gelukt`) users land on after Mollie.

### What I WILL deliver
Server endpoints in the Next.js app (`platform/`), using the Supabase
service-role key server-side only:
- `POST /api/checkout` — body `{ courseSlug }`, requires a logged-in user.
  Creates the Mollie payment + an `orders` row, returns `{ checkoutUrl }`.
- `POST /api/webhooks/mollie` — called by Mollie. **Verifies** the payment by
  re-fetching it from Mollie, is **idempotent** (no double-grant on retries),
  and on success **grants or extends** `course_access.expires_at`.
- Renewal works through the same checkout — buying again **extends** the existing
  expiry rather than replacing it.

### Front-end ↔ payment flow (who does what)
1. User logs in — **front-end** (Supabase Auth, anon key). ✅ already wired.
2. User clicks **Buy** on the pricing page — **front-end** calls
   `POST /api/checkout` with the session, then redirects the browser to the
   returned `checkoutUrl`. *(front-end calls, I provide the endpoint)*
3. User pays at Mollie → Mollie redirects to the **return page** — **front-end**.
4. Return page checks access status and shows success — **front-end** reads it
   (either directly from Supabase `course_access`, RLS-protected, or via a small
   `GET /api/access` helper I can provide).
5. **Access gate:** to unlock the learning area, the front-end checks whether the
   user has a `course_access` row with `expires_at > now()`. *(I provide the
   query/helper; front-end enforces it in the UI.)*

**Net:** I own the payment logic, order/access records, and webhook. Front-end
owns the buttons, pricing page, return page, and gating the UI. The only contract
between us is the `/api/checkout` call and the access-status check.

---

## 3. The 100 exam questions & learning features

### What's done
- 100 original Dutch questions across 4 categories (verkeersregels,
  verkeersinzicht, gevaarherkenning, voertuigkennis & milieu), already loaded
  into Supabase as `questions` + `question_options`, all `published`.
- Each question has an **`image_prompt`** (English) ready for AI image
  generation. 62 of 100 want an illustration; the rest are text-only.
- Content is **gated by active access** via RLS — only users with a valid
  `course_access` row can read questions.

### What I need FROM the front-end / Alex
1. **Who builds the practice/exam UI?**
   - If the **front-end dev** builds it: I deliver a documented **data API /
     query patterns** (list categories, fetch a practice set, submit answers,
     score a mock exam) and the front-end renders it.
   - If **I** build it (inside `platform/`): confirm, and the front-end dev just
     styles/themes it.
2. **Which features are in scope for this agreement** (pick/prioritise):
   - Practice per category (immediate feedback + explanation)
   - **Mock exam** in CBR format — confirm the format (e.g. 65 questions,
     pass at 44, timed?)
   - **Gevaarherkenning** — note: real value needs **video clips** (filmed or
     licensed). The 20 hazard questions already use the CBR
     *Remmen / Gas loslaten / Niets doen* pattern, ready for video later.
   - Progress tracking / weak-spots (spaced repetition)
   - Admin panel to add/edit questions, images, videos *(Alex mentioned this for
     later, once the system works)*
3. **Images:** confirm the AI-image workflow and where they're stored. I
   recommend a **Supabase Storage** bucket; I can wire upload + link each image
   to its question. The prompts are ready in `content/questions.seed.json`.
4. **Content review:** have Alex (or a rijinstructeur) review the 100 questions
   for tone/accuracy before launch. They're original and rule-accurate as of
   2026, but a domain check is wise.
5. **Licensing note for scale:** beyond these 100, a larger bank (and the hazard
   videos) needs licensing or original production — a separate scope/cost item
   for the agreement.

---

## 4. Repo & merge strategy (needs a decision)

Current work lives on the **fork** (`yakubufahad84-web`), not the main repo.
To merge the payment work we need to agree on **one** of:

- **A (recommended): one Next.js codebase.** Front-end dev builds UI inside
  `platform/`; I add the `/api/*` payment + data routes. Single deploy on Vercel.
  Cleanest for "merge the payment," least integration glue.
- **B: separate front-end + payment API.** Front-end is its own app; my payment
  endpoints run as an API the front-end calls over HTTPS. More moving parts; we'd
  fix CORS, shared Supabase keys, and a deploy for each.

Also decide: **how the fork merges into the main repo** — a pull request from the
fork, or the main-repo owner copies the `platform/`, `supabase/`, `content/`,
and `docs/` directories in.

Whatever we pick, both apps **share the same Supabase project** (one database).
Front-end uses the **anon** key (safe in browser); payment back-end uses the
**service-role** key (server-only).

---

## 5. Decisions checklist (for the agreement with Alex)

- [ ] Mollie **test** API key provided (and live key for launch)
- [ ] iDEAL enabled + Mollie profile verified
- [ ] Final **packages, prices, durations** confirmed
- [ ] App **public URL** confirmed (for webhook + redirects)
- [ ] Who builds the **practice/exam UI** (front-end dev vs this stream)
- [ ] **Feature scope** for this phase (practice / mock exam / hazard / progress / admin)
- [ ] **Image** workflow + storage (Supabase Storage bucket?)
- [ ] **Repo strategy**: one codebase (A) or separate API (B)
- [ ] **Merge path** from fork → main repo (PR vs copy-in)
- [ ] Content **review** of the 100 questions by Alex/instructor

---

### TL;DR for the front-end dev
To merge the payment, I need: **(1) a Mollie test key, (2) confirmed
prices/durations, (3) the app's public URL, and (4) two UI pages — a pricing
page with buy buttons and a payment-return page.** I deliver the checkout
endpoint, the verified webhook, and the access-granting logic. For the 100
questions, tell me **who builds the exam UI** and **which features are in scope**,
and I'll either hand you a data API or build the screens inside `platform/`.
