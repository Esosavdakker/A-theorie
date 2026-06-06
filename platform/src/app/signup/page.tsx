import Link from "next/link";
import { signup } from "@/app/auth/actions";

export default async function SignupPage({
  searchParams,
}: {
  searchParams: Promise<{ error?: string }>;
}) {
  const { error } = await searchParams;

  return (
    <main className="container">
      <div className="card">
        <h1>Account aanmaken</h1>
        <p className="subtitle">Begin met oefenen voor je theorie-examen.</p>

        {error && <div className="alert alert-error">{error}</div>}

        <form action={signup}>
          <label htmlFor="full_name">Naam</label>
          <input id="full_name" name="full_name" type="text" autoComplete="name" />

          <label htmlFor="email">E-mailadres</label>
          <input id="email" name="email" type="email" required autoComplete="email" />

          <label htmlFor="password">Wachtwoord</label>
          <input
            id="password"
            name="password"
            type="password"
            required
            minLength={8}
            autoComplete="new-password"
          />

          <button className="primary" type="submit">
            Account aanmaken
          </button>
        </form>

        <p className="center muted">
          Al een account? <Link href="/login">Inloggen</Link>
        </p>
      </div>
    </main>
  );
}
