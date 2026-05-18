import { createMollieClient } from '@mollie/api-client';
import { createClient } from '@supabase/supabase-js';

export default async (req) => {
  if (req.method !== 'POST') {
    return new Response('OK', { status: 200 });
  }

  let body;
  try {
    body = await req.formData();
  } catch {
    return new Response('OK', { status: 200 });
  }

  const paymentId = body.get('id');
  if (!paymentId) return new Response('OK', { status: 200 });

  const mollieKey   = Netlify.env.get('MOLLIE_API_KEY');
  const supabaseUrl = Netlify.env.get('SUPABASE_URL');
  const supabaseKey = Netlify.env.get('SUPABASE_SERVICE_KEY');

  if (!mollieKey || !supabaseUrl || !supabaseKey) {
    console.error('Ontbrekende omgevingsvariabelen');
    return new Response('OK', { status: 200 });
  }

  const mollie   = createMollieClient({ apiKey: mollieKey });
  const supabase = createClient(supabaseUrl, supabaseKey);

  try {
    // Status ophalen bij Mollie (enige betrouwbare bron)
    const payment = await mollie.payments.get(paymentId);
    const { userId, courseId } = payment.metadata;

    // Bestelling bijwerken
    const { data: order, error: orderError } = await supabase
      .from('orders')
      .update({ status: payment.status })
      .eq('mollie_payment_id', paymentId)
      .select('id')
      .single();

    if (orderError || !order) {
      console.error('Order update fout:', orderError?.message);
      return new Response('OK', { status: 200 });
    }

    // Toegang verlenen als betaling geslaagd
    if (payment.isPaid()) {
      await supabase
        .from('course_access')
        .upsert(
          { user_id: userId, course_id: courseId, order_id: order.id },
          { onConflict: 'user_id,course_id' }
        );
    }
  } catch (err) {
    console.error('Webhook fout:', err.message);
  }

  // Altijd 200 teruggeven — Mollie stopt anders met proberen
  return new Response('OK', { status: 200 });
};

export const config = { path: '/api/payment-webhook' };
