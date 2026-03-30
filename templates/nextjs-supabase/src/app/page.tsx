import Link from "next/link";
import { Header } from "@/components/header";
import { Footer } from "@/components/footer";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";

const features = [
  {
    title: "Authentication",
    description: "Email & magic link auth with Supabase, ready out of the box.",
    icon: "🔐",
  },
  {
    title: "Database & RLS",
    description:
      "PostgreSQL with Row Level Security policies for secure data access.",
    icon: "🛡️",
  },
  {
    title: "Khmer Support",
    description:
      "Built-in NotoSansKhmer font support for beautiful Khmer text rendering.",
    icon: "🇰🇭",
  },
  {
    title: "Mobile First",
    description:
      "Responsive design with Tailwind CSS, optimized for mobile devices.",
    icon: "📱",
  },
  {
    title: "Type Safe",
    description:
      "Full TypeScript strict mode with end-to-end type safety.",
    icon: "✅",
  },
  {
    title: "Deploy Ready",
    description:
      "One-click deployment to Vercel with zero configuration needed.",
    icon: "🚀",
  },
];

export default function HomePage() {
  return (
    <div className="flex min-h-screen flex-col">
      <Header />
      <main className="flex-1">
        {/* Hero */}
        <section className="container mx-auto max-w-screen-xl px-4 py-24 text-center md:py-32">
          <h1 className="text-4xl font-bold tracking-tight sm:text-5xl md:text-6xl">
            Build with <span className="text-primary">Confidence</span>
          </h1>
          <p className="mx-auto mt-6 max-w-2xl text-lg text-muted-foreground">
            A production-ready Next.js + Supabase starter template. Auth,
            database, storage, and Khmer language support — everything you need
            to ship fast.
          </p>
          <div className="mt-10 flex flex-col items-center justify-center gap-4 sm:flex-row">
            <Link href="/login">
              <Button size="lg">Get Started</Button>
            </Link>
            <Link
              href="https://github.com/koompi"
              target="_blank"
              rel="noopener noreferrer"
            >
              <Button variant="outline" size="lg">
                View on GitHub
              </Button>
            </Link>
          </div>
        </section>

        {/* Features */}
        <section className="container mx-auto max-w-screen-xl px-4 pb-24">
          <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
            {features.map((feature) => (
              <Card key={feature.title}>
                <CardHeader>
                  <div className="text-3xl">{feature.icon}</div>
                  <CardTitle className="text-lg">{feature.title}</CardTitle>
                  <CardDescription>{feature.description}</CardDescription>
                </CardHeader>
              </Card>
            ))}
          </div>
        </section>

        {/* Khmer Section */}
        <section className="border-t bg-muted/50 py-24">
          <div className="container mx-auto max-w-screen-xl px-4 text-center">
            <h2 className="text-3xl font-bold">សូមស្វាគមន៍</h2>
            <p className="mx-auto mt-4 max-w-xl text-muted-foreground">
              គម្រោងនេះគាំទ្រភាសាខ្មែរយ៉ាងពេញលេញ ជាមួយនឹងពុម្ពអក្សរ NotoSansKhmer
              ដែលបង្ហាញអក្សរខ្មែរយ៉ាងស្រស់ស្អាត។
            </p>
          </div>
        </section>
      </main>
      <Footer />
    </div>
  );
}
