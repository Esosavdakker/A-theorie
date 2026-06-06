import Link from "next/link";
import { redirect } from "next/navigation";
import { createClient } from "@/utils/supabase/server";

// Landing: send logged-in users to the dashboard, others to login/signup.
export default async function Home() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (user) redirect("/dashboard");

  return (
    <main className="container">
      <div className="card">
        <h1>A+theorie leeromgeving</h1>
        <p className="subtitle">
          Oefen voor je CBR theorie-examen: oefenvragen, proefexamens en
          gevaarherkenning.
        </p>
        <Link href="/signup">
          <button className="primary">Account aanmaken</button>
        </Link>
        <p className="center muted">
          Al een account? <Link href="/login">Inloggen</Link>
        </p>
      </div>
    </main>
  );
}
