# STANDARDS.md — Code Quality Bar

## TypeScript
- **Strict mode always.** No `any`, no `// @ts-ignore`, no `// @ts-expect-error`
- Use `interface` over `type` for object shapes
- Use `const` over `let` — never `var`
- Destructure imports and function params
- Named exports only — no default exports
- Async/await — no raw `.then()` chains
- Prefer early returns over nested if/else

## React / Next.js
- **App Router only** — no Pages Router
- **Server Components by default** — Client Components only when needed (state, effects, browser APIs)
- Tailwind CSS for styling — no CSS modules or styled-components
- `shadcn/ui` for UI components (Radix primitives)
- Colocation: components near their pages, utils in `lib/`

## Rust
- **Edition 2024**, Rust 1.85+
- `thiserror` for error types — never `unwrap()` in library code
- `tracing` for logging — never `println!` in production
- `Result<T>` over panics
- `impl Trait` over concrete generics when possible
- No `unsafe` unless documented
- No `todo!()` or `unimplemented!()` in committed code

## Database
- **Supabase**: typed queries (`supabase.from<T>('table')`), RLS on every table
- **PostgreSQL**: use Drizzle ORM for type-safe queries
- **Migrations for all schema changes** — never edit production directly
- Input validation on every endpoint (use zod)

## API Design
- REST by default — GraphQL only when explicitly requested
- Consistent error responses: `{ error: string, code: string }`
- OpenAPI spec for public APIs
- tRPC for end-to-end type safety (when applicable)

## Git
- Conventional commits: `feat:`, `fix:`, `test:`, `docs:`, `chore:`
- Branch: `main` is protected — PRs only
- Small, focused commits — one concern per commit

## General
- **Bun**, not npm/yarn/pnpm
- No hardcoded values — use environment variables
- No `console.log` in production — use structured logging
- No secrets in code or commits
- Lint before commit (Biome)
- Test before ship
