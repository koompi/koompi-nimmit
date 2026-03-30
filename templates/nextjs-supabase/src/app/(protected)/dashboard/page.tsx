import { createClient } from "@/lib/supabase/server";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";

export default async function DashboardPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const { data: profile } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", user!.id)
    .single();

  const initials = (profile?.full_name || user!.email || "U")
    .split(" ")
    .map((n: string) => n[0])
    .join("")
    .toUpperCase()
    .slice(0, 2);

  return (
    <div className="container mx-auto max-w-screen-xl px-4 py-8">
      <h1 className="mb-8 text-3xl font-bold">Dashboard</h1>

      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        {/* Profile Card */}
        <Card>
          <CardHeader>
            <CardTitle>Profile</CardTitle>
            <CardDescription>Your account information</CardDescription>
          </CardHeader>
          <CardContent className="flex items-center gap-4">
            <Avatar className="h-16 w-16">
              {profile?.avatar_url && (
                <AvatarImage src={profile.avatar_url} alt="Avatar" />
              )}
              <AvatarFallback className="text-lg">{initials}</AvatarFallback>
            </Avatar>
            <div>
              <p className="font-medium">
                {profile?.full_name || "No name set"}
              </p>
              <p className="text-sm text-muted-foreground">{user!.email}</p>
            </div>
          </CardContent>
        </Card>

        {/* Welcome Card */}
        <Card>
          <CardHeader>
            <CardTitle>សូមស្វាគមន៍</CardTitle>
            <CardDescription>Welcome to your dashboard</CardDescription>
          </CardHeader>
          <CardContent>
            <p className="text-sm text-muted-foreground">
              This is your protected dashboard. Only authenticated users can see
              this page. Start building your application from here.
            </p>
          </CardContent>
        </Card>

        {/* Quick Stats */}
        <Card>
          <CardHeader>
            <CardTitle>Quick Stats</CardTitle>
            <CardDescription>Sample data display</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-2">
              <div className="flex justify-between">
                <span className="text-sm text-muted-foreground">
                  Account created
                </span>
                <span className="text-sm font-medium">
                  {new Date(user!.created_at).toLocaleDateString()}
                </span>
              </div>
              <div className="flex justify-between">
                <span className="text-sm text-muted-foreground">
                  Auth provider
                </span>
                <span className="text-sm font-medium">
                  {user!.app_metadata?.provider || "email"}
                </span>
              </div>
              <div className="flex justify-between">
                <span className="text-sm text-muted-foreground">Status</span>
                <span className="text-sm font-medium text-green-600">
                  Active
                </span>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
