# FORGE v0.4.0 — The AI-Native Systems Language

> **The only compiled language where `ai_ask()` is a builtin.**
> Native speed. Zero imports. Zero boilerplate.

[![Version](https://img.shields.io/badge/version-0.4.0-orange)](https://forgelang.dev)
[![Platform](https://img.shields.io/badge/platforms-Linux%20%7C%20Windows%20%7C%20Android%20%7C%20Web%20%7C%20macOS-blue)](https://forgelang.dev)
[![Gallery](https://img.shields.io/badge/examples-26-green)](https://gallery.forgelang.dev)
[![VS Code](https://img.shields.io/badge/VS%20Code-v0.4.0-blueviolet)](https://marketplace.visualstudio.com/items?itemName=forgelangdev.forge-lang)

---

## What makes FORGE unique?

```forge
fn main() -> void {
    ai_set_key("your-api-key")

    // AI as a language primitive — no imports, no pip, no boilerplate
    let answer = ai_ask("What is the speed of light?", "")
    print(answer)

    // Zero-shot classification — no ML training needed
    let label = ai_classify("Win $1000!", "spam,important,newsletter")
    print(label)  // spam

    // Translate + sentiment pipeline in 2 lines
    let english = ai_translate("Bonjour monde", "English")
    let mood    = ai_sentiment(english)
    print(mood)  // positive
}
```

**Compare to Python:**
```python
from openai import OpenAI  # pip install openai
client = OpenAI(api_key="sk-...")
response = client.chat.completions.create(
    model="gpt-4",
    messages=[{"role": "user", "content": "What is the speed of light?"}]
)
print(response.choices[0].message.content)
# 8 lines. 1 import. pip required. Python runtime required.
```

**FORGE: 4 lines. Zero imports. Native compiled binary.**

---

## 10 Unique Features

| # | Feature | One-liner |
|---|---------|-----------|
| 1 | **AI stdlib** | `ai_ask()`, `ai_classify()`, `ai_translate()` — native builtins, no SDK |
| 2 | **@parallel** | Add one annotation, compiler parallelises across all CPU cores |
| 3 | **Memory regions** | `region { }` — automatic free, no GC, no malloc |
| 4 | **HTTP server builtins** | `http_listen`, `http_accept`, `http_respond` — zero imports |
| 5 | **Game engine builtins** | SDL2 functions built into the language |
| 6 | **Generics + Traits** | Zero-overhead monomorphisation, compile-time dispatch |
| 7 | **async/await + spawn** | Native concurrency, no framework required |
| 8 | **String + Math stdlib** | `str_upper()`, `math_sin()`, `math_random()` — native |
| 9 | **5-platform compile** | Linux, Windows, Android, Web/WASM, macOS — one flag |
| 10 | **forge new** | Instant project scaffolding |

---

## Quick Start

```bash
# Install
curl -fsSL https://forgelang.dev/install.sh | bash

# Create project
forge new myapp
cd myapp

# Run
forge run main.forge

# Cross-compile
forge build --target windows main.forge
forge build --target web main.forge      # generates .wasm + .html
forge build --target aarch64 main.forge  # Android/ARM64
```

---

## AI Stdlib — Full Reference

```forge
fn main() -> void {
    ai_set_key("sk-...")              // DeepSeek or OpenAI key
    ai_set_model("deepseek-chat")    // optional: default is deepseek-chat

    // Ask AI anything
    let answer = ai_ask("prompt", "optional system context")

    // Classify text (zero-shot, no training)
    let label = ai_classify(text, "label1,label2,label3")

    // Generate code/text
    let code = ai_generate("write a Python bubble sort")

    // Sentiment analysis
    let mood = ai_sentiment(review_text)  // positive/negative/neutral

    // Translation
    let spanish = ai_translate("Hello world", "Spanish")

    // Summarisation
    let summary = ai_summarize(article, 50)  // max 50 words
}
```

---

## String & Math Stdlib

```forge
// String builtins
let up       = str_upper("hello")        // HELLO
let down     = str_lower("HELLO")        // hello
let trimmed  = str_trim("  hello  ")     // hello
let replaced = str_replace(s, "a", "b")
let first    = str_split(csv, ",")       // first token
let starts   = str_starts_with(s, "fn") // 1 or 0
let ends     = str_ends_with(s, ".forge")

// Math builtins
let x = math_pow(2.0, 10.0)  // 1024.0
let y = math_floor(3.7)       // 3.0
let z = math_random()         // 0.0 - 1.0
let s = math_sin(3.14159)
let c = math_cos(0.0)

// Env vars
let home = env_get("HOME")
env_set("MY_KEY", "value")
```

---

## Platform Targets

```bash
forge build main.forge                          # Linux native
forge build --target windows main.forge         # Windows .exe
forge build --target aarch64 main.forge         # Android/ARM64
forge build --target web main.forge             # WASM + HTML wrapper
forge build --target macos main.forge           # macOS binary
forge build --release main.forge                # LLVM -O2 optimised
```

---

## Ecosystem (Live)

| Site | URL |
|------|-----|
| Main | [forgelang.dev](https://forgelang.dev) |
| Online IDE | [ide.forgelang.dev](https://ide.forgelang.dev) |
| Gallery (26 examples) | [gallery.forgelang.dev](https://gallery.forgelang.dev) |
| Docs | [docs.forgelang.dev](https://docs.forgelang.dev) |
| Hub (packages) | [hub.forgelang.dev](https://hub.forgelang.dev) |
| Benchmarks | [bench.forgelang.dev](https://bench.forgelang.dev) |
| Games | [games.forgelang.dev](https://games.forgelang.dev) |

---

## VS Code Extension

Install from marketplace: `forgelangdev.forge-lang` v0.4.0

- Syntax highlighting for all 50+ builtins including AI stdlib
- 31 code snippets (ai_ask, ai_classify, @parallel, HTTP, SDL2...)
- Type-checking on save
- AI model & API key settings

---

## Build from Source

```bash
git clone https://github.com/forgelangdev/phase0
cd forge-lang
/opt/zig/zig build
./zig-out/bin/forge --version  # FORGE v0.4.0
```

Requires: Zig 0.12+, LLVM/Clang, libcurl (for AI stdlib)

---

## Acquisition Target

FORGE is positioned for strategic acquisition at $200M–$2B.

**Why now:** First-mover advantage — the only compiled language with AI as a stdlib primitive.
No other compiled language (Rust, Go, C++, Swift) has `ai_ask()` built in.

Target acquirers: Epic Games · Microsoft (M12) · NVIDIA · Apple · xAI

Contact: dev@forgelang.dev

---

*FORGE v0.4.0 — The AI-Native Systems Language*
*Built with ❤️ and LLVM*
