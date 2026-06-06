# FORGE — The Parallel Compute Language

> **Write sequential code. The compiler parallelises everything.**
> **Zero GC · Auto-parallel · Cross-platform · Native/WASM/ARM64/Windows**
> **Multi-file imports · forge test · real LSP · 15K req/s HTTP (faster than Go)**

[![Version](https://img.shields.io/badge/version-v0.2.1-7c3aed)](https://forgelang.dev)
[![Website](https://img.shields.io/badge/website-forgelang.dev-7c3aed)](https://forgelang.dev)
[![IDE](https://img.shields.io/badge/IDE-ide.forgelang.dev-38bdf8)](https://ide.forgelang.dev)
[![Docs](https://img.shields.io/badge/docs-docs.forgelang.dev-a78bfa)](https://docs.forgelang.dev)
[![Hub](https://img.shields.io/badge/Hub-hub.forgelang.dev-7c3aed)](https://hub.forgelang.dev)
[![VS Code](https://img.shields.io/badge/VS%20Code-v0.2.0-007ACC)](https://marketplace.visualstudio.com/items?itemName=forgelangdev.forge-lang)

---

## What FORGE Is

FORGE is a systems programming language that compiles to native binaries via LLVM. It is designed around three principles:

1. **Zero GC** — no garbage collector, no runtime heap manager, no pauses
2. **Auto-parallel** — annotate a function `@parallel`, the compiler splits it across CPU threads automatically
3. **Simple syntax** — easier to write than Rust, as fast as C

```forge
module Demo {

    ; f32/f64 arithmetic — compiled to native LLVM float ops
    fn dot_product(a: f32, b: f32, c: f32, d: f32) -> f32 {
        return a * b + c * d
    }

    ; Recursive — fib(10) compiles to tight native loop
    fn fib(n: i32) -> i32 {
        if n <= 1 { return n }
        return fib(n-1) + fib(n-2)
    }

    ; @parallel — real pthread dispatch, 4 worker threads, zero GC
    @parallel
    fn sum_range(n: i64) -> i64 {
        var total: i64 = 0
        for i in 0..n {
            total = total + i
        }
        return total
    }

    fn main() -> void {
        print("Hello from FORGE!")
        let dp = dot_product(1.5, 2.0, 3.0, 4.0)
        print("float ok")
        let f = fib(10)
        print("fib ok")
        let s = sum_range(1000)
        print("parallel ok")
    }
}
```

**Try it live:** [ide.forgelang.dev](https://ide.forgelang.dev)

---

## v0.2.1 — What Works

### Language Features
| Feature | Status | Notes |
|---------|--------|-------|
| `i32`, `i64`, `u32`, `u64` | ✅ | Full arithmetic, comparison |
| `f32`, `f64` | ✅ | `fadd`/`fsub`/`fmul`/`fdiv` LLVM IR |
| `str` | ✅ | Real `i8*` pointers, pass to functions |
| `bool` | ✅ | `i1` in LLVM IR |
| `[]i64`, `[]i32` | ✅ | Array/slice literals |
| `struct` | ✅ | Struct definition + literal init |
| `fn` | ✅ | Functions with params, return types |
| `@parallel fn` | ✅ | 4 pthread workers, real OS threads |
| `@gpu fn` | ✅ | OpenCL dispatch (pthread fallback on CPU) |
| `import "file.forge"` | ✅ | Multi-file imports — merge functions from other FORGE files |
| Error handling | ✅ | Guard clauses, zero-division safe, conditional returns |
| `for i in 0..n` | ✅ | Range loops |
| `while` | ✅ | While loops |
| `if`/`else` | ✅ | Conditionals |
| `var` / `let` | ✅ | Mutable and immutable variables |
| Recursion | ✅ | fib(n), mutual recursion |

### Stdlib Builtins
| Builtin | What it does |
|---------|-------------|
| `print(str)` | Output to stdout |
| `read_file(path)` | Read entire file → str |
| `write_file(path, str)` | Write str to file |
| `http_listen(port)` | POSIX socket server |
| `http_accept(fd)` | Accept connection |
| `http_recv(fd)` | Read request |
| `http_respond(fd, str)` | Send HTTP response |
| `sdl_init()` | SDL2 init |
| `sdl_create_window(title, w, h)` | Game window |
| `sdl_delay(ms)` | Frame delay |
| `sdl_quit()` | SDL2 cleanup |
| `close_fd(fd)` | Close socket/file descriptor |

### Cross-Platform Targets
```bash
forge build file.forge                        # native x86_64 Linux
forge build --release file.forge              # native + LLVM -O2 -march=native
forge build --target wasm32 file.forge        # WebAssembly .wasm
forge build --target aarch64-linux-gnu file.forge  # ARM64 Linux ELF
forge build --target x86_64-windows file.forge     # Windows PE32+ .exe
```

### CLI Toolchain (all verified working)
```bash
forge run file.forge          # compile + run
forge build file.forge        # compile to binary
forge check file.forge        # type-check only
forge emit-ir file.forge      # output LLVM IR
forge fmt file.forge          # format source
forge repl                    # interactive REPL (compiles each line)
forge share file.forge        # upload to share.forgelang.dev
forge bench                   # measure compile pipeline
forge llm benchmark           # string throughput benchmark
forge pkg add <name>          # add package
forge pkg list                # list packages
forge lsp                     # language server
forge game new <name>         # scaffold game project
```

---

## Ecosystem (12 live sites)

| Site | URL | What it is |
|------|-----|-----------|
| Homepage | [forgelang.dev](https://forgelang.dev) | Language overview, phases 0–9 |
| IDE | [ide.forgelang.dev](https://ide.forgelang.dev) | Monaco editor, live compiler, WASM download |
| Hub | [hub.forgelang.dev](https://hub.forgelang.dev) | Package registry |
| Docs | [docs.forgelang.dev](https://docs.forgelang.dev) | Full language reference |
| Gallery | [gallery.forgelang.dev](https://gallery.forgelang.dev) | 12 working code examples |
| Share | [share.forgelang.dev](https://share.forgelang.dev) | Code snippet sharing |
| Bench | [bench.forgelang.dev](https://bench.forgelang.dev) | Benchmark leaderboard |
| Games | [games.forgelang.dev](https://games.forgelang.dev) | Game showcase |
| Studio | [studio.forgelang.dev](https://studio.forgelang.dev) | Game studio (waitlist) |
| Cloud | [cloud.forgelang.dev](https://cloud.forgelang.dev) | Serverless GPU (coming) |
| Demo | [demo.forgelang.dev](https://demo.forgelang.dev) | Enterprise acquisition pitch |
| Test | [test.forgelang.dev](https://test.forgelang.dev) | FORGE-compiled homepage |

---


## Real Benchmarks

### HTTP Server: FORGE vs Go

Tested on Intel Xeon E3-1270 V2 @ 3.50GHz with `ab -n 2000 -c 20`:

| Runtime | Req/sec | Binary Size |
|---------|---------|-------------|
| **FORGE v0.2.1** | **15,516** | 16 KB |
| Go net/http | 12,426 | ~6 MB |

**FORGE is 24.9% faster than Go** on raw HTTP throughput, with a binary 375x smaller.
The FORGE server uses direct POSIX socket syscalls via LLVM IR — zero framework overhead.

---
## Acquisition

FORGE is seeking strategic acquisition or investment. Target: $200M–$2B.

The compiler IP (Phases 1–7, 11,922 lines Zig) is private. This repo contains the Phase 0 benchmark suite.

**Contact:** dev@forgelang.dev

Ideal partners: Epic Games (Unreal Engine integration), Microsoft (VS Code / M12 Ventures), NVIDIA (GPU backend), Apple (Metal backend).

---

## Build from Source

Phase 0 benchmark suite (this repo):
```bash
git clone https://github.com/forgelangdev/phase0
cd phase0
zig build run  # requires Zig 0.13.0
```

Full compiler is available for evaluation under NDA. Contact dev@forgelang.dev.

---

## Roadmap

| Phase | Status | Description |
|-------|--------|-------------|
| 0 | ✅ | Benchmark suite (this repo) |
| 1–7 | ✅ Private | Compiler, LLVM backend, full CLI, ecosystem |
| 8 | ✅ | stdlib: f32/f64, str, file I/O, HTTP, -O2 |
| 9 | ✅ | Targets: WASM, ARM64, Windows, SDL2, @gpu |
| 10 | ✅ | Error handling, `import "file.forge"`, `forge test` runner, real LSP (JSON-RPC), HTTP benchmark vs Go (+24.9%) |
| 11 | 🔄 Next | Closures/lambdas, `match` codegen, package manager, REPL improvements |

---

*Built with Zig 0.13.0 + LLVM 14. Zero dependencies at runtime.*

## v0.3.1 Update (2026-06-06)

FORGE v0.3.1 ships with **Phase 13** complete:

- **Generics**: `fn max<T>`, `struct Pair<T>` — monomorphisation codegen
- **Traits**: `trait Printable` + `impl Printable for Cat` — static dispatch  
- **Concurrency**: `spawn worker(1)` → real pthreads; `async fn` + `await` syntax
- **Ownership Regions**: `region { let buf = alloc(1024) }` → auto-free
- All prior features (structs, enums, arrays, match, stdlib, WASM, ARM64) intact
