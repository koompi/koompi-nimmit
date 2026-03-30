import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { Button } from "@/components/ui/button";

export async function Header() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  return (
    <header className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div className="container mx-auto flex h-14 max-w-screen-xl items-center justify-between px-4">
        <Link href="/" className="flex items-center space-x-2">
          <span className="text-xl font-bold">KOOMPI</span>
        </Link>
        <nav className="flex items-center gap-4">
          {user ? (
            <>
              <Link href="/dashboard">
                <Button variant="ghost" size="sm">
                  Dashboard
                </Button>
              </Link>
              <form action="/api/auth/signout" method="post">
                <Button variant="outline" size="sm" type="submit">
                  Sign Out
                </Button>
              </form>
            </>
          ) : (
            <Link href="/login">
              <Button size="sm">Sign In</Button>
            </Link>
          )}
        </nav>
      </div>
    </header>
  );
}
