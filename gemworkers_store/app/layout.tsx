import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "GemWorkers Store",
  description: "Browse publicly listed gemstones from GemWorkers sellers",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
