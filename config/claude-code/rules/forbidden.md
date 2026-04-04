# Forbidden Actions

## Package Managers
- NEVER `npm install`, `npm run`, `npx` — use `bun install`, `bun run`, `bunx`
- NEVER `yarn` or `pnpm`

## Code Smells
- NEVER use `any` type in TypeScript
- NEVER commit `console.log` / `println!` / `print()` debug statements
- NEVER use `TODO` comments without a GitHub issue reference
- NEVER leave placeholder text (lorem ipsum, FIXME without context)

## Security
- NEVER commit secrets, API keys, tokens, or passwords
- NEVER read from `~/.secrets/` — those are for runtime only
- NEVER expose sensitive data in logs, error messages, or API responses
- NEVER use `sudo` in Claude Code sessions

## Git
- NEVER force-push to `main` or `master`
- NEVER commit directly to `main` without a PR
- NEVER squash merge without keeping meaningful commit messages
