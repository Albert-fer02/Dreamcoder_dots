# Skill: Rust War Architecture (Hexagonal & Invariants)

## Context
This skill defines the core architectural standards for Dreamcoder projects, specifically targeting high-stability environments (Government/SUNAT).

## Architecture: Hexagonal (Ports & Adapters)
- **Domain (Core):** Strictly isolated. Must NOT depend on any external libraries or infrastructure. Written in pure Rust.
- **Invariants:** The Domain must enforce business rules at all times. Use the Type System to make illegal states unrepresentable.
- **Auditability:** Implement Event Sourcing concepts. Every change in state must be auditable and reproducible.
- **Ports:** Traits defined in the Domain.
- **Adapters (Infrastructure):** External implementations (DB, API, Filesystem) using Bun or Python where applicable, calling the Rust Core via WASM or FFI.

## Coding Standards
- **Zero-Unsafe:** No `unsafe` code unless strictly necessary for FFI and heavily documented.
- **Error Handling:** Use `Result` for expected errors and `panic!` only for unrecoverable infrastructure failures.
- **Functional Approach:** Prefer immutability and functional patterns (map, filter, fold).

## AI Instructions
When working on the Core:
1. Always ask: "What is the business invariant being protected here?"
2. Ensure no infrastructure leak (no DB types, no HTTP codes in Core).
3. Suggest WASM-compatible patterns for cross-platform portability.
