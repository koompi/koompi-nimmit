export function Footer() {
  return (
    <footer className="border-t py-6">
      <div className="container mx-auto max-w-screen-xl px-4 text-center text-sm text-muted-foreground">
        <p>&copy; {new Date().getFullYear()} KOOMPI. All rights reserved.</p>
      </div>
    </footer>
  );
}
