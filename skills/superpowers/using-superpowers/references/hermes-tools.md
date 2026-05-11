# Hermes Tool Name Mapping

When a superpowers skill references a Claude Code tool, use the Hermes equivalent:

| Claude Code Tool | Hermes Equivalent |
|---|---|
| `Skill` tool | Not needed — skills are injected automatically |
| `Bash` tool | `terminal` tool |
| `Read` tool | `read_file` tool |
| `Write` tool | `write_file` tool |
| `Edit` tool | `read_file` then `write_file` |
| `WebFetch` tool | `web_extract` tool |
| `WebSearch` tool | `web_search` tool |
| `Agent` tool | Spawn subprocess via `terminal` |
| `TodoWrite` / `Task` | Use `terminal` to write/read a `TODO.md` file |
| `Glob` / `Grep` | `terminal` with `find` / `rg` / `grep` |
