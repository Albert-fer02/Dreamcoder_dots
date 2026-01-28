# Skill: Advanced Rust Engineering (2026 Standards)

## Objective
Provide expert-level guidance on Rust development, focusing on performance, safety, and modern asynchronous patterns.

## Core Principles
1. **Memory Safety & Zero-Cost Abstractions:**
   - Use the borrow checker to your advantage. Prefer references over cloning.
   - Leverage `Box`, `Arc`, and `Mutex` only when necessary for shared ownership or heap allocation.
2. **Type-Driven Development:**
   - Use the "Newtype" pattern to enforce domain constraints.
   - Implement `From` and `Into` traits for clean data transformations.
3. **Asynchronous Rust:**
   - Use `tokio` for high-performance I/O.
   - Avoid blocking the executor. Use `spawn_blocking` for CPU-intensive tasks.
4. **Macro Mastery:**
   - Use declarative macros (`macro_rules!`) for boilerplate reduction.
   - Suggest procedural macros only for complex DSLs or attribute-based logic.

## Advanced Patterns
- **Typestate Pattern:** Use different types to represent states in a finite state machine, preventing invalid transitions at compile time.
- **Error Composition:** Use `thiserror` for library errors and `anyhow` or `color-eyre` for application-level error reporting.
- **Zero-Copy Deserialization:** Use `serde` with borrowed data where performance is critical.

## AI Instructions
When assisting with Rust:
- Always suggest `cargo clippy` and `cargo fmt` as part of the workflow.
- Prioritize safety: "Is there a way to do this without `unsafe`?"
- Evaluate performance: "Can we use a stack-allocated array instead of a `Vec`?"
- If the project uses WASM, suggest `wasm-bindgen` optimizations.
