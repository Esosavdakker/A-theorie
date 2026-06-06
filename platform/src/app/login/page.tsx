import Link from "next/link";
import { login } from "@/app/auth/actions";

export default async function LoginPage({
  searchParams,
}: {
  searchParams: Promise<{ error?: string; message?: string }>;
}) {
  const { error, message } = await searchParams;

  return (
    <main className="container">
      <div className="card">
        <h1>Inloggen</h1>
        <p className="subtitle">Welkom terug bij A+theorie.</p>

        {message && <div className="alert alert-success">{message}</div>}
        {error && <div className="alert alert-error">{error}</div>}

        <form action={login}>
          <label htmlFor="email">E-mailadres</label>
          <input id="email" name="email" type="email" required autoComplete="email" />

          <label htmlFor="password">Wachtwoord</label>
          <input
            id="password"
            name="password"
            type="password"
            required
            autoComplete="current-password"
          />

          <button className="primary" type="submit">
            Inloggen
          </button>
        </form>

        <p className="center muted">
          Nog geen account? <Link href="/signup">Account aanmaken</Link>
        </p>
      </div>
    </main>
  );
}
