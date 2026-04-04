# TypeScript Rules

## Strict Mode
- Always `strict: true` in tsconfig.json
- No `any` — use `unknown` if the type is truly unknown
- No `@ts-ignore` or `@ts-expect-error` unless absolutely necessary
- Prefer `interface` over `type` for object shapes
- Use `as const` for literal types

## Patterns
- Prefer early returns over nested if/else
- Destructure function parameters
- Use template literals over string concatenation
- Prefer `Map`/`Set` over plain objects for key-value/collection
- Async/await over .then() chains

## Forbidden
- `var` — always `const` or `let`
- `==` / `!=` — always `===` / `!==`
- `console.log` in production code — use `tracing` or structured logging
- Default exports — named exports only
