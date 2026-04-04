# Testing Rules

## When to Test
- Every new function that has logic branches
- Every bug fix — write a regression test
- Every API endpoint
- Not: pure UI layout, trivial getters/setters

## How to Test
- `bun test` for TypeScript projects
- `cargo test` for Rust projects
- `pytest` for Python projects
- Test behavior, not implementation
- Name tests clearly: `should [expected behavior] when [condition]`

## Anti-Patterns
- Don't test library internals — test your code's contract with the library
- Don't mock everything — mock at boundaries (API, DB, filesystem)
- Don't write tests that test nothing meaningful
