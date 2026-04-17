export default async (req) => {
  if (req.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'Method not allowed' }), {
      status: 405,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  let body;
  try {
    body = await req.json();
  } catch {
    return new Response(JSON.stringify({ error: 'Ongeldig verzoek.' }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  const { name, email, phone, message, honeypot } = body;

  // Honeypot: silently succeed if a bot filled the hidden field
  if (honeypot) {
    return new Response(JSON.stringify({ success: true }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  if (!name || !email || !message) {
    return new Response(JSON.stringify({ error: 'Naam, e-mail en bericht zijn verplicht.' }), {
      status: 422,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    return new Response(JSON.stringify({ error: 'Ongeldig e-mailadres.' }), {
      status: 422,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  const toEmail = Netlify.env.get('CONTACT_EMAIL');
  const apiKey  = Netlify.env.get('EMAIL_API_KEY');

  if (!toEmail || !apiKey) {
    console.error('Missing env vars: CONTACT_EMAIL or EMAIL_API_KEY');
    return new Response(JSON.stringify({ error: 'Serverfout. Probeer het later opnieuw.' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  const phoneHtml = phone ? `<p><strong>Telefoon:</strong> ${phone}</p>` : '';
  const messageHtml = message.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/\n/g, '<br>');

  try {
    const emailRes = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${apiKey}`,
      },
      body: JSON.stringify({
        from: 'A+theorie Contact <noreply@aplustheorie.nl>',
        to: [toEmail],
        reply_to: email,
        subject: `Nieuw contactbericht van ${name}`,
        html: `
          <h2 style="color:#1e3a8a">Nieuw bericht via aplustheorie.nl</h2>
          <p><strong>Naam:</strong> ${name}</p>
          <p><strong>E-mail:</strong> ${email}</p>
          ${phoneHtml}
          <p><strong>Bericht:</strong></p>
          <p>${messageHtml}</p>
        `,
      }),
    });

    if (!emailRes.ok) {
      const err = await emailRes.text();
      console.error('Resend API error:', emailRes.status, err);
      throw new Error(`Email API ${emailRes.status}`);
    }
  } catch (err) {
    console.error('Email send failed:', err);
    return new Response(JSON.stringify({ error: 'Verzenden mislukt. Probeer het later opnieuw.' }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    });
  }

  return new Response(
    JSON.stringify({ success: true, message: 'Bericht ontvangen! We nemen zo snel mogelijk contact op.' }),
    { status: 200, headers: { 'Content-Type': 'application/json' } }
  );
};

export const config = {
  path: '/api/contact',
};
