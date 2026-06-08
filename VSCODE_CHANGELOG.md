# FORGE Lang VS Code Extension — Changelog

## v0.4.0 (2026-06-08) — Phase 14 — AI-Native
- **AI stdlib highlighting**: `ai_ask`, `ai_classify`, `ai_generate`, `ai_sentiment`, `ai_translate`, `ai_summarize`, `ai_set_key`, `ai_set_model` highlighted as builtins (orange)
- **String builtins**: `str_upper`, `str_lower`, `str_trim`, `str_replace`, `str_starts_with`, `str_ends_with`, `str_split` highlighted
- **Math builtins**: `math_pow`, `math_floor`, `math_ceil`, `math_sin`, `math_cos`, `math_random` highlighted
- **Env builtins**: `env_get`, `env_set` highlighted
- **4 new AI snippets**: `ai_ask`, `ai_classify`, `ai_pipeline`, `ai_generate`
- **3 new stdlib snippets**: `str_ops`, `env_get`, `forge_new`
- **31 total snippets** (was 24)
- New settings: `forge.ai.defaultModel`, `forge.ai.apiKey`
- README rewritten with AI-Native positioning
- Packaged: `forge-lang-0.4.0.vsix`

## v0.3.0 (2026-06-06) — Phase 12+13
- **Generics**: syntax highlighting + snippets for `fn max<T>`, `struct Pair<T>`
- **Traits**: `trait` keyword highlighted, `forgetrait` snippet
- **Concurrency**: `spawn` keyword highlighted, `forgespawn` snippet
- **Regions**: `region` keyword highlighted, `forgeregion` snippet
- **Async**: `async`/`await` already supported, added `forgeasync` snippet
- Bumped to reflect FORGE compiler v0.3.1

## v0.2.1 (2026-06-06) — Phase 12
- Structs + impl + methods
- Enums
- Arrays
- stdlib builtins

## v0.1.0 — Initial release
- Basic syntax highlighting
- Core snippets (fn, struct, match, for, if)
- File icon for .forge files
