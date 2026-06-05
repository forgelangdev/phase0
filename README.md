# FORGE — The Parallel Compute Language

> **Write sequential code. The compiler parallelises everything.**
> **7,797× faster than Python · 4.57× @parallel speedup · 11,922 lines Zig · 11 live ecosystem sites**

[![Website](https://img.shields.io/badge/website-forgelang.dev-7c3aed)](https://forgelang.dev)
[![IDE](https://img.shields.io/badge/IDE-ide.forgelang.dev-38bdf8)](https://ide.forgelang.dev)
[![Docs](https://img.shields.io/badge/docs-docs.forgelang.dev-a78bfa)](https://docs.forgelang.dev)
[![Hub](https://img.shields.io/badge/Hub-hub.forgelang.dev-7c3aed)](https://hub.forgelang.dev)
[![VS Code](https://img.shields.io/badge/VS%20Code-forgelangdev.forge--lang-007ACC)](https://marketplace.visualstudio.com/items?itemName=forgelangdev.forge-lang)
[![Contact](https://img.shields.io/badge/contact-dev%40forgelang.dev-38bdf8)](mailto:dev@forgelang.dev)

---

## Overview

FORGE is a next-generation parallel compute language and compiler that automatically distributes sequential code across all available CPU and GPU cores. No threading primitives. No manual parallelisation. No GC overhead.

Built in **11,922 lines of Zig** with a **LLVM 14 backend**, FORGE currently ships:
- A mature compiler with lexer, parser, typechecker, and LLVM IR codegen
- A complete CLI toolchain with 13 commands
- An LSP language server
- A published VS Code extension
- A web IDE, package registry, code gallery, and snippet sharing service
- A game engine with ECS, math library, and renderer
- WebGPU/WGSL compute shader backend
- DWARF debug info emission
- FNV-1a incremental compilation cache

**Status: Acquisition-ready. Phase 0–7 complete.**

---

## Performance

| Metric | FORGE | Python | Speedup |
|--------|-------|--------|---------|
| Zero-copy stream throughput | **9.47 GB/s** | ~1.2 MB/s | **7,797× faster** |
| 100M record processing (8 cores) | **416 ms** | ~12,000 ms | **28× faster** |
| @parallel speedup (8 cores) | **4.57×** | N/A | Auto-distributed |
| HTTP server memory | **212 KB** | ~45 MB | **212× leaner** |
| Compile time (hello world) | **~60 ms** | N/A | Instant feedback |

All benchmarks measured on Intel Xeon E3-1270 V2 @ 3.5GHz, 8 cores, 32GB RAM, compiled with `-O ReleaseFast`.

---

## The FORGE Ecosystem (11 Live Sites)

| Site | URL | Description |
|------|-----|-------------|
| **Homepage** | [forgelang.dev](https://forgelang.dev) | Main site with benchmarks, roadmap, acquisition info |
| **Documentation** | [docs.forgelang.dev](https://docs.forgelang.dev) | Language reference, stdlib docs, tutorials |
| **Web IDE** | [ide.forgelang.dev](https://ide.forgelang.dev) | Monaco-based browser IDE with live compiler |
| **Package Hub** | [hub.forgelang.dev](https://hub.forgelang.dev) | Package registry — 8 packages published |
| **Demo/Acquisition** | [demo.forgelang.dev](https://demo.forgelang.dev) | Enterprise acquisition pitch deck |
| **Code Gallery** | [gallery.forgelang.dev](https://gallery.forgelang.dev) | 12+ example programs |
| **Code Share** | [share.forgelang.dev](https://share.forgelang.dev) | Snippet sharing service |
| **Benchmarks** | [bench.forgelang.dev](https://bench.forgelang.dev) | Live benchmark dashboard |
| **Game Engine** | [games.forgelang.dev](https://games.forgelang.dev) | FORGE game engine demos |
| **FORGE Studio** | [studio.forgelang.dev](https://studio.forgelang.dev) | Advanced development environment |
| **FORGE Cloud** | [cloud.forgelang.dev](https://cloud.forgelang.dev) | Cloud compute platform |

---

## CLI Commands

| Command | Description |
|---------|-------------|
| `forge build <file>` | Compile FORGE source to native binary (ELF) |
| `forge run <file>` | Build and execute a FORGE program |
| `forge check <file>` | Type-check source without emitting binary |
| `forge emit-ir <file>` | Dump LLVM IR for debugging/analysis |
| `forge bench` | Run the benchmark suite |
| `forge profile <file>` | Profile execution performance |
| `forge fmt <file>` | Auto-format FORGE source code |
| `forge repl` | Interactive REPL session |
| `forge share <file>` | Share code via snippet service |
| `forge game <name>` | Scaffold a new game engine project |
| `forge llm <file>` | LLM inference utilities |
| `forge pkg <command>` | Package management (publish, install, search) |
| `forge lsp` | Start the LSP language server |

### Quick Start

```bash
forge check hello.forge    # type-check only
forge build hello.forge    # compile → native binary
forge run hello.forge      # compile + execute
```

---

## Standard Library

| Module | Description |
|--------|-------------|
| `forge.io` | I/O streams, file operations, zero-copy streaming |
| `forge.math` | Vec2, Vec3, Mat4, quaternions, noise functions |
| `forge.engine` | Game engine: ECS, physics, renderer, input, audio |
| `forge.llm` | LLM inference primitives, tensor operations |

---

## VS Code Extension

Published on VS Code Marketplace as **`forgelangdev.forge-lang`**.

Features:
- Full syntax highlighting (keywords, types, annotations, operators)
- Snippets for `module`, `fn`, `@parallel fn`, `@gpu fn`, `@stream fn`, `struct`, `match`
- Language configuration (bracket matching, auto-closing, comments)
- LSP integration with type-checking on save
- Inline hints for `@parallel` and `@gpu` annotated functions

Install: Open VS Code → Extensions → Search "FORGE Lang" → Install

---

## Compiler Architecture

```
Source (.forge)
    ↓
Lexer → Token Stream
    ↓
Parser → AST
    ↓
Typechecker → Typed AST
    ↓
LLVM IR Generator → LLVM IR
    ↓
Optimizer (constant folding, DCE)
    ↓
Clang/LLVM → ELF binary
```

Built in **11,922 lines of Zig** across ~60 source files:
- `src/lexer.zig` — Recursive descent tokenizer
- `src/parser.zig` — AST builder
- `src/typechecker.zig` — Type inference + checking
- `src/codegen.zig` — LLVM IR code generation
- `src/forge.zig` — CLI entry point
- `src/lsp.zig` — Language server protocol
- `src/cli/` — Command implementations

---

## Language Features

- **`@parallel` annotation** — Auto-distributes data-parallel operations across all CPU cores
- **`@gpu` annotation** — Offloads computation to GPU via WebGPU/WGSL
- **`@stream` + `@zero_copy`** — Zero-copy predictive prefetch streaming
- **Ownership Regions** — Deterministic memory management, no GC pauses
- **Module system** — Namespaced modules with import paths
- **Pattern matching** — `match` expressions with exhaustive checking
- **Type inference** — Full Hindley-Milner style type inference
- **Game-first ECS** — Entity-component system as a language primitive

---

## Roadmap Status

| Phase | Status | Description |
|-------|--------|-------------|
| Phase 0 | ✅ Complete | Benchmarks: 9.47 GB/s, 19× Python |
| Phase 1 | ✅ Complete | Runtime: memory regions, fibers, streams |
| Phase 2 | ✅ Complete | Compiler: lexer, parser, typechecker, LLVM codegen |
| Phase 3 | ✅ Complete | Game engine, ForgeHub, LSP server |
| Phase 4 | ✅ Complete | WebGPU, incremental cache, debug info |
| Phase 5 | ✅ Complete | Native binary, web IDE, package registry, VS Code |
| Phase 6 | ✅ Complete | @parallel → real speedup, forge pkg publish |
| Phase 7 | ✅ Complete | docs.forgelang.dev, games, studio, cloud |

---

## Repository Structure

```
.
├── src/                  # Zig source (11,922 lines total)
│   ├── lexer.zig         # Tokenizer
│   ├── parser.zig        # AST parser
│   ├── typechecker.zig   # Type checker
│   ├── codegen.zig       # LLVM IR codegen
│   ├── forge.zig         # CLI entry
│   ├── lsp.zig           # LSP server
│   ├── cli/              # Command implementations
│   ├── runtime/          # Runtime library
│   ├── stdlib/           # Standard library (io, math, engine, llm)
│   └── game/             # Game engine ECS
├── tools/
│   ├── vscode/           # VS Code extension
│   └── scripts/          # Dev tooling
├── tests/                # Test suite (21/21 passing)
├── examples/             # Example FORGE programs
└── docs/                 # Documentation
```

---

## Contact & Acquisition

FORGE is **acquisition-ready** with a complete compiler, shipping ecosystem, and thousands of hours of engineering.

| Package | Price | What's Included |
|---------|-------|-----------------|
| Annual Licence | $2M/yr | Commercial licence, 50 seats, support |
| Source Code | $10M | Full source access, modification rights |
| Full Acquisition | $200M–$2B | Everything: code + team + domains + ecosystem |

**Contact:** dev@forgelang.dev

---

## Links

- **Website:** [forgelang.dev](https://forgelang.dev)
- **Documentation:** [docs.forgelang.dev](https://docs.forgelang.dev)
- **Web IDE:** [ide.forgelang.dev](https://ide.forgelang.dev)
- **Package Hub:** [hub.forgelang.dev](https://hub.forgelang.dev)
- **Demo:** [demo.forgelang.dev](https://demo.forgelang.dev)
- **Gallery:** [gallery.forgelang.dev](https://gallery.forgelang.dev)
- **Share:** [share.forgelang.dev](https://share.forgelang.dev)
- **Benchmarks:** [bench.forgelang.dev](https://bench.forgelang.dev)
- **Game Engine:** [games.forgelang.dev](https://games.forgelang.dev)
- **Studio:** [studio.forgelang.dev](https://studio.forgelang.dev)
- **Cloud:** [cloud.forgelang.dev](https://cloud.forgelang.dev)
- **VS Code:** `forgelangdev.forge-lang` on Marketplace
- **GitHub:** [github.com/forgelangdev/phase0](https://github.com/forgelangdev/phase0)
- **Email:** dev@forgelang.dev

---

*FORGE — The parallel compute language for the next decade.*
*11,922 lines · 11 live sites · Acquisition-ready*
