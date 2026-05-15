# A+theorie — Payment Backend

Node.js + Express backend handling Mollie iDEAL payments and course access via Supabase.

## Stack

- **Runtime:** Node.js (ESM)
- **Framework:** Express
- **Database:** PostgreSQL via Supabase
- **Payments:** Mollie iDEAL

## Setup

```bash
npm install
cp .env.example .env
# Fill in .env with your credentials
npm run dev
```

## Database

Run `schema.sql` in the Supabase SQL Editor to create the required tables.

## Environment Variables

| Variable | Description |
|----------|-------------|
| `PORT` | Server port (default: 3000) |
| `MOLLIE_API_KEY` | Mollie API key (test\_ or live\_) |
| `SUPABASE_URL` | Supabase project URL |
| `SUPABASE_SERVICE_KEY` | Supabase service role key |
| `BACKEND_URL` | Public URL of this server (HTTPS in production) |
| `FRONTEND_URL` | Frontend URL for CORS and redirects |

## API

### `POST /payment/create`
Creates a Mollie iDEAL payment.

**Body:**
```json
{ "userId": "uuid", "courseId": "uuid" }
```

**Response:**
```json
{ "checkoutUrl": "https://...", "paymentId": "tr_xxx" }
```

### `GET /payment/access/:userId/:courseId`
Check whether a user has paid access to a course.

**Response:**
```json
{ "hasAccess": true, "grantedAt": "2025-05-15T10:00:00Z" }
```

### `POST /webhooks/mollie`
Mollie payment status webhook. Called automatically by Mollie — do not call manually.

### `GET /health`
Returns `{ "status": "ok" }`.

## Deployment

1. Push to GitHub
2. Connect repo to [Railway](https://railway.app) or [Render](https://render.com)
3. Add environment variables in the hosting dashboard
4. Ensure `BACKEND_URL` is an HTTPS URL — required by Mollie for webhooks
5. Switch `MOLLIE_API_KEY` from `test_` to `live_` when going live
