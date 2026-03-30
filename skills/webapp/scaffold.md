# Scaffold Procedure

Create a new Next.js 16 + Supabase project from the template.

## Prerequisites

- Claude Code available via `sessions_spawn(runtime="acp", agentId="claude")`
- Template at `~/workspace/koompi-nimmit/templates/nextjs-supabase/`
- Supabase CLI installed (`supabase`)
- Target directory: `~/workspace/<project-slug>/`

## Steps

### 1. Prepare the brief

Gather from user or infer:
```yaml
name: "Restaurant Ordering App"
slug: restaurant-ordering
description: "Online ordering with menu, cart, and checkout"
features:
  - Menu browsing with categories
  - Add to cart
  - Checkout form (name, phone, address)
  - Order confirmation
style:
  colors: { primary: "#FF6B35", secondary: "#004E89", accent: "#F7C59F" }
  font: "NotoSansKhmer"  # always include Khmer font
  dark: false
database:
  tables:
    - menus (id, name, description, price, category_id, image_url, active)
    - categories (id, name, sort_order)
    - orders (id, customer_name, phone, address, total, status, items_json, created_at)
    - order_items (id, order_id, menu_id, quantity, price)
deploy_target: vercel  # or kconsole, self-hosted
```

### 2. Clone and customize (Claude Code)

Spawn Claude Code with this task:

```
You are scaffolding a new Next.js 16 + Supabase web application.

TEMPLATE: Copy everything from ~/workspace/koompi-nimmit/templates/nextjs-supabase/
TARGET: ~/workspace/<slug>/

Customize the template for this project:
- App name: <name>
- Update package.json name field
- Update metadata in src/app/layout.tsx
- Create database migration at supabase/migrations/<timestamp>_init.sql with the schema above
- Create RLS policies (authenticated users can read menus, insert orders; anon can read menus)
- Build the pages:
  - / (home) — hero section + featured items
  - /menu — full menu with category filters
  - /order — cart + checkout form
  - /order/success — confirmation page
- Use shadcn/ui components (Button, Card, Input, Sheet for mobile cart)
- Use Tailwind with the specified colors
- Mobile responsive (mobile-first)
- Include NotoSansKhmer font (loaded in layout.tsx)
- Server Components by default, Client Components only where needed

When done:
1. Run `bun install` to verify dependencies
2. Run `bun run build` to verify it compiles
3. Report the result
```

### 3. Verify locally

```bash
cd ~/workspace/<slug>/
bun install
bun run build
```

If build fails, fix in the same Claude Code session.

### 4. Initialize git

```bash
cd ~/workspace/<slug>/
git init
git add -A
git commit -m "feat: scaffold <name>"
```

### 5. Report

Return to user with:
- Project location
- Pages created
- Database schema overview
- Ready for deploy confirmation
