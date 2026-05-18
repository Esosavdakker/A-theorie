import { createClient } from '@supabase/supabase-js';

const json = (data, status = 200) =>
  new Response(JSON.stringify(data), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });

export default async (req) => {
  if (req.method !== 'GET') return json({ error: 'Method not allowed' }, 405);

  const url      = new URL(req.url);
  const userId   = url.searchParams.get('userId');
  const courseId = url.searchParams.get('courseId');

  if (!userId || !courseId) return json({ error: 'userId en courseId zijn verplicht.' }, 400);

  const supabaseUrl = Netlify.env.get('SUPABASE_URL');
  const supabaseKey = Netlify.env.get('SUPABASE_SERVICE_KEY');

  if (!supabaseUrl || !supabaseKey) return json({ error: 'Serverfout.' }, 500);

  const supabase = createClient(supabaseUrl, supabaseKey);

  const { data, error } = await supabase
    .from('course_access')
    .select('id, granted_at')
    .eq('user_id', userId)
    .eq('course_id', courseId)
    .single();

  if (error && error.code !== 'PGRST116') {
    console.error('Toegangscheck fout:', error.message);
    return json({ error: 'Toegangscheck mislukt.' }, 500);
  }

  if (!data) return json({ hasAccess: false });

  return json({ hasAccess: true, grantedAt: data.granted_at });
};

export const config = { path: '/api/payment-access' };
