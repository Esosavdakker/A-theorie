import Link from "next/link";

export default function ErrorPage() {
  return (
    <main className="container">
      <div className="card">
        <h1>Er ging iets mis</h1>
        <p className="subtitle">
          De link is mogelijk verlopen of al gebruikt. Probeer opnieuw in te
          loggen of vraag een nieuwe bevestigingsmail aan.
        </p>
        <Link href="/login">
          <button className="primary">Terug naar inloggen</button>
        </Link>
      </div>
    </main>
  );
}
