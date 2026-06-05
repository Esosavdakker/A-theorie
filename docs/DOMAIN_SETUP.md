# Domein-koppeling: aplustheorie.nl

Stappenplan voor DNS, Netlify en Resend configuratie vóór live-gang.
Voer de stappen in volgorde A → B → C uit. DNS-propagatie duurt 1–24 uur.

---

## A. Netlify — custom domain instellen

### 1. Domein toevoegen

1. Log in op [app.netlify.com](https://app.netlify.com) en open je site.
2. Ga naar **Site configuration → Domain management → Domains**.
3. Klik **Add a domain**.
4. Typ `aplustheorie.nl` (apex, zonder www) en klik **Verify**.
5. Netlify vraagt of je de eigenaar bent — klik **Yes, add domain**.
6. Voeg daarna ook `www.aplustheorie.nl` toe via dezelfde knop.

### 2. Primair domein instellen (apex als canonical)

In het overzicht onder **Custom domains**:

- Zet `aplustheorie.nl` als **Primary domain** (knop of "Set as primary").
- `www.aplustheorie.nl` verschijnt automatisch als redirect → apex.

### 3. Force HTTPS aanzetten

1. Ga naar **Site configuration → Domain management → HTTPS**.
2. Wacht tot Let's Encrypt het certificaat heeft uitgegeven (zie stap 4).
3. Zet de toggle **Force HTTPS** aan zodra het certificaat actief is.

> De `netlify.toml` in dit project bevat al HTTP→HTTPS en www→apex redirects
> als extra laag, maar de Netlify-toggle is de primaire schakelaar.

### 4. Let's Encrypt SSL

Netlify vraagt automatisch een Let's Encrypt-certificaat aan zodra de DNS-records
correct staan (zie sectie B). Dit duurt normaal **5–15 minuten** na volledige propagatie.

Status check: **Site configuration → Domain management → HTTPS**
→ moet "Your site has HTTPS enabled" tonen.

---

## B. GoDaddy DNS-records instellen

> **Belangrijk:** gebruik **DNS Management**, niet de Domain Forwarding feature.
> Forwarding werkt op HTTP-niveau en breekt HTTPS. Het pad in GoDaddy:
> **Mijn Producten → Domeinen → [aplustheorie.nl] → DNS beheren**

### A-record (apex `@`)

| Veld | Waarde |
|------|--------|
| Type | **A** |
| Naam/Host | `@` |
| Waarde/Points to | `75.2.60.5` |
| TTL | 1 uur (3600) |

> Verifieer het huidige Netlify load balancer IP in je Netlify dashboard onder
> **Domain management → DNS settings** — het kan zijn dat Netlify een ander IP
> toont als ze hun infrastructuur hebben gewijzigd. `75.2.60.5` is het bekende IP
> ten tijde van het schrijven van dit document.

Als GoDaddy al een A-record op `@` heeft (standaard parkeer-IP):
→ bewerk dat record in plaats van een nieuw aan te maken.

### CNAME-record (www)

| Veld | Waarde |
|------|--------|
| Type | **CNAME** |
| Naam/Host | `www` |
| Waarde/Points to | `<jouw-sitenaam>.netlify.app` |
| TTL | 1 uur (3600) |

Vervang `<jouw-sitenaam>` met de naam die Netlify aan je site heeft gegeven,
te vinden in **Site configuration → General → Site details → Site name**.

> GoDaddy staat geen CNAME op `@` toe (apex). Gebruik daarom het A-record
> hierboven voor de apex en het CNAME alleen voor `www`.

---

## C. Resend — e-mail DNS records

Voor het contactformulier (`info@aplustheorie.nl` via Resend).

> **Stap 0:** Voeg het domein toe in het Resend dashboard:
> [resend.com/domains](https://resend.com/domains) → **Add Domain** → `aplustheorie.nl`
> Resend toont dan de exacte DNS-waarden voor jouw account. Gebruik die waarden.

### SPF (TXT op `@`)

| Veld | Waarde |
|------|--------|
| Type | **TXT** |
| Naam/Host | `@` |
| Waarde | `v=spf1 include:_spf.resend.com ~all` |
| TTL | 1 uur |

> Als er al een SPF-record op `@` staat (bijv. van GoDaddy zelf), voeg dan
> `include:_spf.resend.com` toe aan de bestaande waarde — er mag maar één
> SPF TXT-record op `@` staan.

### DKIM (CNAME — waarde uit Resend dashboard)

Resend geeft per domein een uniek DKIM-record. Haal de exacte waarden op uit
**Resend → Domains → aplustheorie.nl → DNS Records**.

Typische vorm:

| Veld | Waarde |
|------|--------|
| Type | **CNAME** |
| Naam/Host | `resend._domainkey` (of wat Resend opgeeft) |
| Waarde | `<unieke-waarde>.dkim.resend.com` |
| TTL | 1 uur |

### DMARC (TXT op `_dmarc`)

| Veld | Waarde |
|------|--------|
| Type | **TXT** |
| Naam/Host | `_dmarc` |
| Waarde | `v=DMARC1; p=none; rua=mailto:info@aplustheorie.nl` |
| TTL | 1 uur |

> `p=none` betekent: monitor-modus, geen e-mail wordt geweigerd. Zodra je
> zeker bent dat verzending correct werkt, kun je upgraden naar `p=quarantine`
> of `p=reject`.

---

## D. Verificatie — commando's

Voer deze uit na de propagatietijd (minimaal 1 uur, plan op 24 uur):

```bash
# A-record apex — verwacht: 75.2.60.5
dig aplustheorie.nl +short

# CNAME www — verwacht: <sitenaam>.netlify.app of doorverwijzing naar Netlify
dig www.aplustheorie.nl +short

# SPF TXT record — verwacht: regel met v=spf1 ... include:_spf.resend.com
dig TXT aplustheorie.nl +short

# DMARC TXT record — verwacht: v=DMARC1; p=none ...
dig TXT _dmarc.aplustheorie.nl +short

# DKIM CNAME (vervang 'resend._domainkey' indien Resend een andere naam opgeeft)
dig CNAME resend._domainkey.aplustheorie.nl +short
```

### Verwachte uitvoer per commando

| Commando | Verwacht resultaat |
|----------|--------------------|
| `dig aplustheorie.nl +short` | `75.2.60.5` |
| `dig www.aplustheorie.nl +short` | `<sitenaam>.netlify.app.` |
| `dig TXT aplustheorie.nl +short` | bevat `v=spf1 include:_spf.resend.com` |
| `dig TXT _dmarc.aplustheorie.nl +short` | `"v=DMARC1; p=none; ..."` |

### Online tools als alternatief

- [dnschecker.org](https://dnschecker.org) — wereldwijde propagatie-check per record
- [mxtoolbox.com/spf](https://mxtoolbox.com/spf.aspx) — SPF validatie
- [resend.com/domains](https://resend.com/domains) — Resend toont zelf of DKIM verified is

---

## E. netlify.toml — redirects

De volgende regels staan al in `netlify.toml` in dit project:

```toml
# HTTP → HTTPS (301)
[[redirects]]
  from   = "http://aplustheorie.nl/*"
  to     = "https://aplustheorie.nl/:splat"
  status = 301
  force  = true

[[redirects]]
  from   = "http://www.aplustheorie.nl/*"
  to     = "https://aplustheorie.nl/:splat"
  status = 301
  force  = true

# www → apex (301)
[[redirects]]
  from   = "https://www.aplustheorie.nl/*"
  to     = "https://aplustheorie.nl/:splat"
  status = 301
  force  = true
```

> **Geen SPA fallback (`/* /index.html 200`) toegevoegd.**
> Dit is een Astro hybrid/SSR site — de Netlify adapter genereert automatisch
> een serverless function die alle routing afhandelt. Een handmatige 200-fallback
> naar `index.html` zou server-side routes breken en conflicteren met de
> gegenereerde `_redirects`. De adapter handelt onbekende routes correct af.

---

## Volgorde samenvatting

```
1. Netlify: domein toevoegen (sectie A)
2. GoDaddy: A + CNAME records instellen (sectie B)
3. Wacht ~1 uur op propagatie
4. Netlify: controleer of SSL-certificaat actief is → Force HTTPS aanzetten
5. Resend: domein toevoegen → DKIM/SPF/DMARC records instellen (sectie C)
6. Verificeer met dig-commando's (sectie D)
7. Stuur testmail via Resend en check ontvangst op info@aplustheorie.nl
```

Propagatietijd: **1–24 uur**. Plan je launch-dag zo dat de DNS-records
minimaal een dag van tevoren zijn ingesteld.
