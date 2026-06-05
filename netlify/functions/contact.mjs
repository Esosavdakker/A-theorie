import { Resend } from 'resend';

// In-memory rate limiter — MVP: per-instance only. Replace with Redis for multi-instance scale.
const rateMap = new Map();
const RATE_LIMIT  = 5;
const RATE_WINDOW = 10 * 60 * 1000;

function checkRateLimit(ip) {
  const now = Date.now();
  for (const [key, val] of rateMap) {
    if (now > val.resetAt) rateMap.delete(key);
  }
  const entry = rateMap.get(ip);
  if (!entry || now > entry.resetAt) {
    rateMap.set(ip, { count: 1, resetAt: now + RATE_WINDOW });
    return true;
  }
  if (entry.count >= RATE_LIMIT) return false;
  entry.count++;
  return true;
}

function respond(data, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });
}

function escHtml(str) {
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

export default async (req) => {
  if (req.method !== 'POST') return respond({ error: 'Method not allowed' }, 405);

  const ip = req.headers.get('x-forwarded-for')?.split(',')[0]?.trim() ?? 'unknown';
  if (!checkRateLimit(ip)) {
    return respond({ error: 'Te veel verzoeken. Probeer het over 10 minuten opnieuw.' }, 429);
  }

  let body;
  try {
    body = await req.json();
  } catch {
    return respond({ error: 'Ongeldig verzoek.' }, 400);
  }

  const { naam, email, telefoon, vraag, honeypot } = body;

  if (honeypot) return respond({ success: true, message: 'Bericht ontvangen!' });

  const errors = {};
  const emailRe = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

  if (!naam || typeof naam !== 'string' || naam.trim().length === 0) {
    errors.naam = 'Naam is verplicht.';
  } else if (naam.trim().length > 100) {
    errors.naam = 'Naam mag maximaal 100 tekens bevatten.';
  }

  if (!email || typeof email !== 'string' || !emailRe.test(email.trim())) {
    errors.email = 'Voer een geldig e-mailadres in.';
  } else if (email.trim().length > 150) {
    errors.email = 'E-mailadres mag maximaal 150 tekens bevatten.';
  }

  if (telefoon && typeof telefoon === 'string' && telefoon.trim().length > 20) {
    errors.telefoon = 'Telefoonnummer mag maximaal 20 tekens bevatten.';
  }

  if (!vraag || typeof vraag !== 'string' || vraag.trim().length === 0) {
    errors.vraag = 'Vul je vraag in.';
  } else if (vraag.trim().length > 2000) {
    errors.vraag = 'Vraag mag maximaal 2000 tekens bevatten.';
  }

  if (Object.keys(errors).length > 0) return respond({ errors }, 400);

  const apiKey = Netlify.env.get('RESEND_API_KEY');
  if (!apiKey) {
    console.error('RESEND_API_KEY is not set');
    return respond({ error: 'Serverfout. Probeer het later opnieuw.' }, 500);
  }

  const resend   = new Resend(apiKey);
  const naamVal  = naam.trim();
  const emailVal = email.trim();
  const telVal   = telefoon?.trim() || null;
  const vraagVal = vraag.trim();

  const html = `<!DOCTYPE html>
<html lang="nl">
<head><meta charset="UTF-8"></head>
<body style="font-family:system-ui,sans-serif;color:#1e293b;max-width:600px;margin:0 auto;padding:24px">
  <h2 style="color:#0066CC;border-bottom:2px solid #e2e8f0;padding-bottom:12px;margin-bottom:24px">
    Nieuw bericht via aplustheorie.nl
  </h2>
  <table style="width:100%;border-collapse:collapse">
    <tr style="border-bottom:1px solid #e2e8f0">
      <td style="padding:10px 0;font-weight:600;width:130px;color:#475569;vertical-align:top">Naam</td>
      <td style="padding:10px 0">${escHtml(naamVal)}</td>
    </tr>
    <tr style="border-bottom:1px solid #e2e8f0">
      <td style="padding:10px 0;font-weight:600;color:#475569;vertical-align:top">E-mail</td>
      <td style="padding:10px 0">
        <a href="mailto:${escHtml(emailVal)}" style="color:#0066CC">${escHtml(emailVal)}</a>
      </td>
    </tr>
    ${telVal ? `<tr style="border-bottom:1px solid #e2e8f0">
      <td style="padding:10px 0;font-weight:600;color:#475569;vertical-align:top">Telefoon</td>
      <td style="padding:10px 0">${escHtml(telVal)}</td>
    </tr>` : ''}
    <tr>
      <td style="padding:10px 0;font-weight:600;color:#475569;vertical-align:top">Vraag</td>
      <td style="padding:10px 0;line-height:1.6">${escHtml(vraagVal).replace(/\n/g, '<br>')}</td>
    </tr>
  </table>
  <p style="margin-top:32px;color:#94a3b8;font-size:13px;border-top:1px solid #e2e8f0;padding-top:16px">
    Verzonden via het contactformulier op aplustheorie.nl
  </p>
</body>
</html>`;

  const lines = [
    'Nieuw bericht via aplustheorie.nl',
    '',
    `Naam:     ${naamVal}`,
    `E-mail:   ${emailVal}`,
  ];
  if (telVal) lines.push(`Telefoon: ${telVal}`);
  lines.push('', 'Vraag:', vraagVal);
  const text = lines.join('\n');

  try {
    const { data, error } = await resend.emails.send({
      from:     'A+theorie Contactformulier <info@aplustheorie.nl>',
      to:       ['jasrijschool@gmail.com'],
      reply_to: emailVal,
      subject:  `[A+theorie] Vraag van ${naamVal}`,
      html,
      text,
    });

    if (error) {
      console.error('Resend error:', error);
      return respond({ error: 'Verzenden mislukt. Probeer het later opnieuw.' }, 500);
    }

    console.log('Email sent, Resend message ID:', data.id);
    return respond({ success: true, message: 'Bericht ontvangen! We nemen zo snel mogelijk contact op.' });
  } catch (err) {
    console.error('Email send exception:', err?.message);
    return respond({ error: 'Verzenden mislukt. Probeer het later opnieuw.' }, 500);
  }
};

export const config = { path: '/api/contact' };
