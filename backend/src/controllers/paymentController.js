import mollie from '../db/mollie.js';
import supabase from '../db/supabase.js';

export async function createPayment(req, res) {
  const { userId, courseId } = req.body;

  if (!userId || !courseId) {
    return res.status(400).json({ error: 'userId and courseId are required.' });
  }

  try {
    const { data: course, error: courseError } = await supabase
      .from('courses')
      .select('id, title, price')
      .eq('id', courseId)
      .single();

    if (courseError || !course) {
      return res.status(404).json({ error: 'Course not found.' });
    }

    const { data: existingAccess } = await supabase
      .from('course_access')
      .select('id')
      .eq('user_id', userId)
      .eq('course_id', courseId)
      .single();

    if (existingAccess) {
      return res.status(409).json({ error: 'User already has access to this course.' });
    }

    const payment = await mollie.payments.create({
      method: 'ideal',
      amount: {
        currency: 'EUR',
        value: course.price.toFixed(2),
      },
      description: `A+theorie – ${course.title}`,
      redirectUrl: `${process.env.FRONTEND_URL}/payment/return?courseId=${courseId}`,
      webhookUrl: `${process.env.BACKEND_URL}/webhooks/mollie`,
      metadata: { userId, courseId },
    });

    const { error: orderError } = await supabase.from('orders').insert({
      user_id: userId,
      course_id: courseId,
      mollie_payment_id: payment.id,
      amount: course.price,
      status: 'open',
    });

    if (orderError) {
      return res.status(500).json({ error: 'Failed to create order.' });
    }

    return res.status(201).json({
      checkoutUrl: payment.getCheckoutUrl(),
      paymentId: payment.id,
    });
  } catch {
    return res.status(500).json({ error: 'Payment creation failed.' });
  }
}

export async function mollieWebhook(req, res) {
  const paymentId = req.body?.id;

  if (!paymentId) {
    return res.status(200).send('OK');
  }

  try {
    const payment = await mollie.payments.get(paymentId);
    const { userId, courseId } = payment.metadata;

    const { data: order, error: orderError } = await supabase
      .from('orders')
      .update({ status: payment.status })
      .eq('mollie_payment_id', paymentId)
      .select('id')
      .single();

    if (orderError || !order) {
      return res.status(200).send('OK');
    }

    if (payment.isPaid()) {
      await supabase
        .from('course_access')
        .upsert(
          { user_id: userId, course_id: courseId, order_id: order.id },
          { onConflict: 'user_id,course_id' }
        );
    }

    return res.status(200).send('OK');
  } catch {
    return res.status(200).send('OK');
  }
}

export async function checkAccess(req, res) {
  const { userId, courseId } = req.params;

  try {
    const { data, error } = await supabase
      .from('course_access')
      .select('id, granted_at')
      .eq('user_id', userId)
      .eq('course_id', courseId)
      .single();

    if (error || !data) {
      return res.status(200).json({ hasAccess: false });
    }

    return res.status(200).json({ hasAccess: true, grantedAt: data.granted_at });
  } catch {
    return res.status(500).json({ error: 'Access check failed.' });
  }
}
