import type { Metadata } from "next";
import { Noto_Sans_Khmer } from "next/font/google";
import "./globals.css";

const notoSansKhmer = Noto_Sans_Khmer({
  subsets: ["khmer", "latin"],
  variable: "--font-noto-sans-khmer",
  display: "swap",
});

export const metadata: Metadata = {
  title: "KOOMPI - Build with Confidence",
  description:
    "A production-ready Next.js + Supabase starter template with Khmer support.",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="km" className={notoSansKhmer.variable}>
      <body className="min-h-screen font-[family-name:var(--font-noto-sans-khmer)] antialiased">
        {children}
      </body>
    </html>
  );
}
