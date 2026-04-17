# A+theorie — Claude Context

## Project Summary
Static marketing website for A+theorie, a Dutch driving theory school owned by Alex.
Built with Astro + Netlify. 5 Dutch pages, serverless contact form.

## Tech Stack
- Framework: Astro 4.x (output: hybrid)
- Deployment: Netlify
- Styling: Vanilla CSS with custom properties (no Tailwind, no CSS-in-JS)
- Functions: Netlify serverless (netlify/functions/*.mjs)
- Email: Resend API (swappable)

## Critical Architecture Rules
1. ALL client-specific content lives in `src/config/site.config.js`. Never hardcode Dutch text in components.
2. Design tokens live exclusively in `src/styles/tokens.css`. Never use raw hex values or px sizes in component styles.
3. Use `Netlify.env.get('KEY')` in serverless functions — never `process.env.KEY`.
4. Functions use `.mjs` extension with Web Request API format (no CommonJS).
5. Run `netlify dev` for local development to test serverless functions alongside the site.

## File Structure
```
src/components/ui/        → Button, Card, Input
src/components/sections/  → Hero, About, Courses, Pricing, FAQ, CTA
src/components/layout/    → Navbar, Footer
src/layouts/              → BaseLayout.astro
src/pages/                → index, over-ons, cursussen, prijzen, contact
src/config/               → site.config.js (single source of truth)
src/styles/               → tokens.css (design tokens)
netlify/functions/        → contact.mjs (POST /api/contact)
public/                   → static assets
```

## Page Routes
| Page      | File                       | URL         |
|-----------|----------------------------|-------------|
| Home      | src/pages/index.astro      | /           |
| Over Ons  | src/pages/over-ons.astro   | /over-ons   |
| Cursussen | src/pages/cursussen.astro  | /cursussen  |
| Prijzen   | src/pages/prijzen.astro    | /prijzen    |
| Contact   | src/pages/contact.astro    | /contact    |

## Environment Variables (set in Netlify dashboard)
- `CONTACT_EMAIL` — email address that receives contact form submissions
- `EMAIL_API_KEY` — Resend API key (resend.com, free tier works)

## Commands
```bash
npm install        # install dependencies
netlify dev        # local dev with function emulation (port 8888)
npm run build      # production build → dist/
astro preview      # preview production build locally
```

## Brand Colors
| Token                  | Value     | Usage                  |
|------------------------|-----------|------------------------|
| `--color-primary`      | `#0066CC` | Blue                   |
| `--color-primary-dark` | `#1e3a8a` | Dark blue, gradients   |
| `--color-accent`       | `#f97316` | Orange, CTAs           |
| `--color-white`        | `#ffffff` | Backgrounds            |
| `--color-text`         | `#1e293b` | Body text              |

## Post-Deploy Checklist for Alex
1. Set `CONTACT_EMAIL` and `EMAIL_API_KEY` in Netlify → Site configuration → Environment variables
2. Update placeholder contact info in `src/config/site.config.js`
3. Add a real `public/og-image.jpg` (1200×630px) for social sharing
4. Sign up at resend.com (free), get API key, verify your domain
