const GITHUB_RAW = "https://raw.githubusercontent.com/koompi/koompi-nimmit/main";

export default {
  async fetch(request: Request): Promise<Response> {
    const url = new URL(request.url);
    const path = url.pathname;

    // GET /install → serve install.sh
    if (path === "/install" || path === "/install.sh") {
      const res = await fetch(`${GITHUB_RAW}/install.sh`);
      if (!res.ok) {
        return new Response("Failed to fetch install script", { status: 502 });
      }
      const body = await res.text();
      return new Response(body, {
        headers: {
          "Content-Type": "text/plain; charset=utf-8",
          "Cache-Control": "public, max-age=300",
        },
      });
    }

    // GET /skill-packs/<industry>/SKILL.md
    const skillMatch = path.match(/^\/skill-packs\/([a-z-]+)\/SKILL\.md$/);
    if (skillMatch) {
      const industry = skillMatch[1];
      const res = await fetch(`${GITHUB_RAW}/skill-packs/${industry}/SKILL.md`);
      if (!res.ok) {
        return new Response(`Skill pack '${industry}' not found`, { status: 404 });
      }
      const body = await res.text();
      return new Response(body, {
        headers: {
          "Content-Type": "text/markdown; charset=utf-8",
          "Cache-Control": "public, max-age=300",
        },
      });
    }

    // GET / → landing
    if (path === "/" || path === "") {
      return new Response(
        [
          "# Nimmit",
          "",
          "AI-powered business assistant by KOOMPI.",
          "",
          "## Install",
          "",
          "```bash",
          "curl -fsSL https://nimmit.koompi.ai/install | bash",
          "```",
          "",
          "## Skill Packs",
          "",
          "- [SME](/skill-packs/sme/SKILL.md)",
          "- [Education](/skill-packs/education/SKILL.md)",
          "- [Executive](/skill-packs/executive/SKILL.md)",
          "- [Government](/skill-packs/government/SKILL.md)",
        ].join("\n"),
        {
          headers: {
            "Content-Type": "text/markdown; charset=utf-8",
          },
        }
      );
    }

    return new Response("Not found", { status: 404 });
  },
} satisfies ExportedHandler;
