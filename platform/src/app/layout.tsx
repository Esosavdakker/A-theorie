import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "A+theorie — Leeromgeving",
  description: "Oefen voor je CBR theorie-examen.",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="nl">
      <body>{children}</body>
    </html>
  );
}
