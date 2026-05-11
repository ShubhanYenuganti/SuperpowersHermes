You are implementing the `superpowers-hermes` project: a port of the Superpowers development methodology (https://github.com/obra/superpowers) to Hermes Agent by NousResearch.

## What to build

A package that brings all 14 superpowers skills into Hermes Agent's native skill system, with a thin Python tool to define the `superpowers` toolset.

## Working directory

`/Users/shubhan/superpowers-hermes/`

## Source files (upstream superpowers content — READ ONLY)

All upstream skill content lives at:
```
~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/
```

Skill directories to port:
- using-superpowers
- brainstorming
- systematic-debugging
- test-driven-development
- writing-plans
- executing-plans
- subagent-driven-development
- dispatching-parallel-agents
- requesting-code-review
- receiving-code-review
- finishing-a-development-branch
- using-git-worktrees
- verification-before-completion
- writing-skills

Each has a `SKILL.md`. Some have additional files:
- `systematic-debugging/find-polluter.sh` → copy verbatim
- `subagent-driven-development/implementer-prompt.md` → copy verbatim
- `subagent-driven-development/code-quality-reviewer-prompt.md` → copy verbatim

## Output file structure to create

```
/Users/shubhan/superpowers-hermes/
├── README.md
├── tools/
│   └── superpowers.py
├── skills/
│   └── superpowers/
│       ├── DESCRIPTION.md
│       ├── using-superpowers/
│       │   ├── SKILL.md
│       │   └── references/
│       │       └── hermes-tools.md
│       ├── brainstorming/
│       │   └── SKILL.md
│       ├── systematic-debugging/
│       │   ├── SKILL.md
│       │   └── scripts/
│       │       └── find-polluter.sh
│       ├── subagent-driven-development/
│       │   ├── SKILL.md
│       │   ├── implementer-prompt.md
│       │   └── code-quality-reviewer-prompt.md
│       └── <one dir per remaining skill>/
│           └── SKILL.md
└── install.sh
```

## Step-by-step implementation

### 1. Create `tools/superpowers.py`

```python
from tools.registry import registry

SCHEMA = {
    "type": "object",
    "properties": {
        "query": {"type": "string", "description": "Skill name to describe"}
    },
    "required": []
}

def handle(args, **kwargs):
    return "Superpowers methodology skills are active and injected into your context."

registry.register(
    name="superpowers_active",
    toolset="superpowers",
    schema=SCHEMA,
    handler=handle,
    description="Confirms superpowers methodology skills are active",
    emoji="⚡",
)
```

### 2. For EVERY skill EXCEPT `using-superpowers`:

Read the upstream `SKILL.md`, then write a new one with:

a) **Prepend this YAML frontmatter** (replace placeholders):
```yaml
---
name: <skill-directory-name>
description: <extract the one-line description from the upstream skill body or its first paragraph>
version: 5.1.0
author: Jesse Vincent
license: MIT
metadata:
  hermes:
    tags: [Development, Methodology]
    related_skills: [using-superpowers]
    requires_toolsets: [superpowers]
---
```

b) **In the body**, find any paragraph that tells the user to "use the Skill tool" or "invoke via Skill({...})" and replace it with:
`*(This skill is automatically injected into your context when the superpowers toolset is active.)*`

c) Keep everything else in the body **exactly verbatim** — do not paraphrase, summarize, or rewrite any methodology content.

### 3. For `using-superpowers` specifically:

Read the upstream `SKILL.md`, then write a new one with:

a) **Prepend this YAML frontmatter** (NO requires_toolsets — this skill is always injected):
```yaml
---
name: using-superpowers
description: Bootstrap skill — establishes the Superpowers methodology and how to invoke other skills
version: 5.1.0
author: Jesse Vincent
license: MIT
metadata:
  hermes:
    tags: [Development, Methodology]
---
```

b) **Immediately after the frontmatter, before the original body**, insert this section:
```markdown
## Hermes Integration Note

You are running in Hermes Agent. Skills are injected into this context automatically when
the `superpowers` toolset is active — you do not need to "invoke" them explicitly via a tool.
All other superpowers skills are already in your context.
See `references/hermes-tools.md` for the Claude Code → Hermes tool name mapping.

```

c) **In the body**, replace any paragraph about using the `Skill` tool to invoke other skills with:
`*(In Hermes, all superpowers skills are injected into your context automatically — no explicit invocation needed.)*`

d) Keep everything else **exactly verbatim**.

### 4. Create `skills/superpowers/using-superpowers/references/hermes-tools.md`

```markdown
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
```

### 5. Create `skills/superpowers/DESCRIPTION.md`

```markdown
# Superpowers

Software development methodology skills ported from https://github.com/obra/superpowers
by Jesse Vincent. Provides structured, opinionated workflows for planning, TDD, debugging,
code review, subagent orchestration, and more.

Enable with: `hermes tools --enable superpowers`
```

### 6. Copy helper files verbatim

- `~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/systematic-debugging/find-polluter.sh`
  → `skills/superpowers/systematic-debugging/scripts/find-polluter.sh`

- `~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/subagent-driven-development/implementer-prompt.md`
  → `skills/superpowers/subagent-driven-development/implementer-prompt.md`

- `~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/subagent-driven-development/code-quality-reviewer-prompt.md`
  → `skills/superpowers/subagent-driven-development/code-quality-reviewer-prompt.md`

### 7. `writing-skills` — extra adaptation

This skill explains how to write new skills for Claude Code's plugin system. Rewrite the "how to publish/install" section to describe the Hermes format instead:
- YAML frontmatter with `name`, `description`, `version`, `author`, `license`, `metadata.hermes.*`
- Place in `skills/<category>/<skill-name>/SKILL.md`
- Install with `install.sh` or copy directly to `~/.hermes/skills/`
- Test by enabling the toolset and checking system prompt injection
Keep the methodology content (when to write a skill, what makes a good skill, etc.) verbatim.

### 8. Create `install.sh`

```bash
#!/usr/bin/env bash
set -e
HERMES_DIR="${HERMES_HOME:-$HOME/.hermes}"
mkdir -p "$HERMES_DIR/skills" "$HERMES_DIR/tools"

cp -r skills/superpowers "$HERMES_DIR/skills/"
echo "✓ Installed skills → $HERMES_DIR/skills/superpowers/"

cp tools/superpowers.py "$HERMES_DIR/tools/"
echo "✓ Installed toolset → $HERMES_DIR/tools/superpowers.py"

echo ""
echo "Run: hermes tools --enable superpowers"
```

Make it executable: `chmod +x install.sh`

### 9. Create `README.md`

Include:
- One-paragraph description of what this is
- Prerequisites: Hermes Agent installed (`pip install hermes-agent` or equivalent)
- Install steps: clone, run `./install.sh`, run `hermes tools --enable superpowers`
- Acceptance test: in a Hermes session, send "Let's make a react todo list" — the brainstorming skill should trigger before any code is written
- Note: the `brainstorming` skill references a visual companion server (in the upstream repo's `skills/brainstorming/scripts/`) — not ported here, link to upstream for it
- Source: upstream repo https://github.com/obra/superpowers (v5.1.0), MIT license

## Verification checklist

After creating all files, verify:
1. `ls skills/superpowers/` shows exactly 14 directories
2. Every skill directory (except `using-superpowers`) has `requires_toolsets: [superpowers]` in its frontmatter
3. `using-superpowers/SKILL.md` has NO `requires_toolsets` in frontmatter
4. `tools/superpowers.py` exists and contains `registry.register`
5. `install.sh` is executable
6. `using-superpowers/references/hermes-tools.md` exists

Report what was created when done.
