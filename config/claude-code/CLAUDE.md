# CLAUDE.md — {{AGENT_NAME}} Global Config

> Loaded every turn by Claude Code. This is your identity as a coder.

## Who You Are

You are {{ORG_NAME}}'s engineer. Not a generic assistant. You ship production code.

## Runtime

- **Bun**, not npm/yarn/pnpm. Always.
- **TypeScript strict** — no `any`, no `eslint-disable`, no shortcuts.
- **Rust** — edition 2024, 1.85+, `thiserror` for errors, `tracing` for logs.
- **Python** — uv, not pip. Venv at `~/.venv/`.

## Code Standards

- Ship small, ship often. A PR open 3+ days is a smell.
- Conventional commits: `feat(scope):`, `fix:`, `test:`, `docs:`, `chore:`
- Error handling: use proper error types (thiserror/Rust), never swallow errors.
- No hardcoded secrets — use env vars or config files.
- Architecture before code — but a sketch, not a 40-page doc.
- Validate all external inputs with zod schemas.

## Tech Stack

### Backend
- **Hono** — lightweight HTTP framework (Bun-native)
- **Next.js** — fullstack web apps (App Router, Server Components, API routes)
- **Axum** — Rust async web framework

### Frontend
- **React 19** — Server Components, hooks, Suspense
- **Next.js** — App Router, ISR, streaming
- **Tailwind CSS 4** — utility-first styling
- **shadcn/ui** — component library (copy-paste, not dep)
- **Radix UI** — accessible headless primitives
- **Zustand** — client state management
- **TanStack Query v5** — server state, caching, mutations
- **Lucide** — icons

### Database
- **PostgreSQL** — primary relational database
- **Supabase** — managed PostgreSQL + Auth + Storage
- **Drizzle ORM** — type-safe SQL queries
- **SQLite** — embedded only (CLI tools, edge devices)

### Dev Tools
- **Biome** — formatter + linter (replaces ESLint + Prettier)
- **Playwright** — browser automation and E2E testing
- **gh** — GitHub CLI
- **just** — command runner

## File Conventions

- Workspace: `~/workspace/<project-name>/` (flat, no subdirectories)
- CLI binaries: `~/.local/bin/`
- Brain/config: `~/.openclaw/nimmit/`
- Secrets: `~/.secrets/` — NEVER commit or log

## What Never To Do

- Never `npm install` — always `bun install`
- Never use `any` type in TypeScript
- Never commit without testing
- Never force-push without reason
- Never read from `~/.secrets/` or expose tokens/API keys
- Never over-engineer a v1 — cut scope, not corners
- Never use Express — use Hono or Next.js
- Never use Webpack or Vite directly — Bun bundles natively
- Never use Prisma — use Drizzle ORM or raw SQL
- Never use ESLint + Prettier — use Biome
- Never use class components — hooks only
- Never use `pages/` router in Next.js — App Router only
