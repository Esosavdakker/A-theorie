import { createMollieClient } from '@mollie/api-client';
import { createClient } from '@supabase/supabase-js';

const json = (data, status = 200) =>
  new Response(JSON.stringify(data), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });

export default async (req) => {
  if (req.method !== 'POST') return json({ error: 'Method not allowed' }, 405);

  let body;
  try {
    body = await req.json();
  } catch {
    return json({ error: 'Ongeldig verzoek.' }, 400);
  }

  const { userId, courseId } = body;
  if (!userId || !courseId) return json({ error: 'userId en courseId zijn verplicht.' }, 400);

  const mollieKey   = Netlify.env.get('MOLLIE_API_KEY');
  const supabaseUrl = Netlify.env.get('SUPABASE_URL');
  const supabaseKey = Netlify.env.get('SUPABASE_SERVICE_KEY');
  const backendUrl  = Netlify.env.get('BACKEND_URL');
  const frontendUrl = Netlify.env.get('FRONTEND_URL');

  if (!mollieKey || !supabaseUrl || !supabaseKey || !backendUrl || !frontendUrl) {
    console.error('Ontbrekende omgevingsvariabelen');
    return json({ error: 'Serverfout.' }, 500);
  }

  const mollie   = createMollieClient({ apiKey: mollieKey });
  const supabase = createClient(supabaseUrl, supabaseKey);

  // Cursus ophalen
  const { data: course, error: courseError } = await supabase
    .from('courses')
    .select('id, title, price')
    .eq('id', courseId)
    .single();

  if (courseError || !course) return json({ error: 'Cursus niet gevonden.' }, 404);

  // Controleer of gebruiker al toegang heeft
  const { data: existingAccess } = await supabase
    .from('course_access')
    .select('id')
    .eq('user_id', userId)
    .eq('course_id', courseId)
    .single();

  if (existingAccess) return json({ error: 'Gebruiker heeft al toegang tot deze cursus.' }, 409);

  // Betaling aanmaken bij Mollie
  let payment;
  try {
    payment = await mollie.payments.create({
      method: 'ideal',
      amount: { currency: 'EUR', value: Number(course.price).toFixed(2) },
      description: `A+theorie – ${course.title}`,
      redirectUrl: `${frontendUrl}/betaling/bevestiging?courseId=${courseId}`,
      webhookUrl:  `${backendUrl}/api/payment-webhook`,
      metadata: { userId, courseId },
    });
  } catch (err) {
    console.error('Mollie fout:', err.message);
    return json({ error: 'Betaling aanmaken mislukt.' }, 500);
  }

  // Bestelling opslaan
  const { error: orderError } = await supabase.from('orders').insert({
    user_id:           userId,
    course_id:         courseId,
    mollie_payment_id: payment.id,
    amount:            course.price,
    status:            'open',
  });

  if (orderError) {
    console.error('Order insert fout:', orderError.message);
    return json({ error: 'Bestelling opslaan mislukt.' }, 500);
  }

  return json({ checkoutUrl: payment.getCheckoutUrl(), paymentId: payment.id }, 201);
};

export const config = { path: '/api/payment-create' };
