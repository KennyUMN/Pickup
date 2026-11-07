# Pickup (samethread)

Python package `samethread` in `src/`, plus a Bun/OpenTUI session picker in `tui/`.

## Verify

Run `make check` (pytest via `uv`, no setup needed) before calling any change done, and show its output. When a mistake repeats, add a test that catches it instead of another line here.

The TUI has no typecheck yet: run `bun install` first, then `bunx tsc --noEmit`.
