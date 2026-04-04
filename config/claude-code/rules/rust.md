# Rust Rules

## Edition & Version
- Edition 2024, Rust 1.85+
- Keep `Cargo.lock` committed

## Patterns
- Use `thiserror` for error types — never `unwrap()` in library code
- Prefer `Result<T>` over panics
- Use `tracing` crate for logging, not `println!`
- Use `#[cfg(feature = "...")]` for optional features

## Forbidden
- No `unsafe` unless absolutely necessary — document why
- No `expect()` in library code — use `thiserror` + `Result`
- No `todo!()` or `unimplemented!()` in committed code
