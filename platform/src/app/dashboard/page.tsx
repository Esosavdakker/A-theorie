import { redirect } from "next/navigation";
import { createClient } from "@/utils/supabase/server";
import { signout } from "@/app/auth/actions";

export default async function DashboardPage() {
  const supabase = await createClient();

  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  // Live time-boxed access check: only rows that haven't expired.
  const { data: access } = await supabase
    .from("course_access")
    .select("expires_at, courses(title)")
    .gt("expires_at", new Date().toISOString())
    .order("expires_at", { ascending: false });

  const active = access ?? [];
  const hasAccess = active.length > 0;
  const expiresAt = hasAccess ? new Date(active[0].expires_at) : null;

  return (
    <main className="container">
      <div className="card">
        <h1>Dashboard</h1>
        <p className="subtitle">Ingelogd als {user.email}</p>

        {hasAccess ? (
          <>
            <span className="badge badge-active">Toegang actief</span>
            <p className="muted" style={{ marginTop: 12 }}>
              Je toegang is geldig tot{" "}
              <strong>
                {expiresAt!.toLocaleDateString("nl-NL", {
                  day: "numeric",
                  month: "long",
                  year: "numeric",
                })}
              </strong>
              .
            </p>
          </>
        ) : (
          <>
            <span className="badge badge-inactive">Geen actieve toegang</span>
            <p className="muted" style={{ marginTop: 12 }}>
              Je hebt nog geen geldige toegang. Kies een pakket om te beginnen
              met oefenen. (Betaling volgt in Fase 2.)
            </p>
          </>
        )}

        <form action={signout} style={{ marginTop: 8 }}>
          <button className="primary" type="submit">
            Uitloggen
          </button>
        </form>
      </div>
    </main>
  );
}
