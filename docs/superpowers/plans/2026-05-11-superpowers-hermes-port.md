# Superpowers-Hermes Port Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Port all 14 Superpowers methodology skills from Claude Code's plugin system into Hermes Agent's native YAML+Markdown skill format, with a thin Python toolset definition.

**Architecture:** Thin Python tool (`tools/superpowers.py`) registers the `superpowers` toolset; 13 of the 14 skills are gated behind `requires_toolsets: [superpowers]`; the `using-superpowers` bootstrap skill is always-injected (no `requires_toolsets`), mirroring the upstream always-on behavior. Skill bodies are preserved verbatim except for Skill-tool invocation paragraphs and platform-specific install sections.

**Tech Stack:** Bash (file creation/copying), Python (toolset definition, no external deps), Hermes Agent skill YAML frontmatter format (v5.1.0 upstream source).

**Source files (READ ONLY):** `~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/`

**Output root:** `/Users/shubhan/superpowers-hermes/`

---

## File Map

| File | Action | Purpose |
|---|---|---|
| `tools/superpowers.py` | Create | Toolset registration |
| `skills/superpowers/DESCRIPTION.md` | Create | Toolset description |
| `skills/superpowers/using-superpowers/SKILL.md` | Create | Bootstrap skill (always-injected) |
| `skills/superpowers/using-superpowers/references/hermes-tools.md` | Create | Claude Code → Hermes tool mapping |
| `skills/superpowers/brainstorming/SKILL.md` | Create | Standard port |
| `skills/superpowers/test-driven-development/SKILL.md` | Create | Standard port |
| `skills/superpowers/writing-plans/SKILL.md` | Create | Standard port |
| `skills/superpowers/executing-plans/SKILL.md` | Create | Standard port |
| `skills/superpowers/dispatching-parallel-agents/SKILL.md` | Create | Standard port |
| `skills/superpowers/requesting-code-review/SKILL.md` | Create | Standard port |
| `skills/superpowers/receiving-code-review/SKILL.md` | Create | Standard port |
| `skills/superpowers/verification-before-completion/SKILL.md` | Create | Standard port |
| `skills/superpowers/finishing-a-development-branch/SKILL.md` | Create | Standard port |
| `skills/superpowers/using-git-worktrees/SKILL.md` | Create | Standard port |
| `skills/superpowers/systematic-debugging/SKILL.md` | Create | Standard port |
| `skills/superpowers/systematic-debugging/scripts/find-polluter.sh` | Copy verbatim | Helper script |
| `skills/superpowers/subagent-driven-development/SKILL.md` | Create | Standard port |
| `skills/superpowers/subagent-driven-development/implementer-prompt.md` | Copy verbatim | Subagent prompt |
| `skills/superpowers/subagent-driven-development/code-quality-reviewer-prompt.md` | Copy verbatim | Reviewer prompt |
| `skills/superpowers/writing-skills/SKILL.md` | Create | Port with Hermes install section rewrite |
| `install.sh` | Create | Installation script |
| `README.md` | Create | Project documentation |

---

### Task 1: Directory Structure + Toolset Definition

**Files:**
- Create: `tools/superpowers.py`
- Create: `skills/superpowers/DESCRIPTION.md`
- Create all skill subdirectories

- [ ] **Step 1: Create directory tree**

```bash
cd /Users/shubhan/superpowers-hermes
mkdir -p tools
mkdir -p skills/superpowers/using-superpowers/references
mkdir -p skills/superpowers/brainstorming
mkdir -p skills/superpowers/test-driven-development
mkdir -p skills/superpowers/writing-plans
mkdir -p skills/superpowers/executing-plans
mkdir -p skills/superpowers/dispatching-parallel-agents
mkdir -p skills/superpowers/requesting-code-review
mkdir -p skills/superpowers/receiving-code-review
mkdir -p skills/superpowers/verification-before-completion
mkdir -p skills/superpowers/finishing-a-development-branch
mkdir -p skills/superpowers/using-git-worktrees
mkdir -p skills/superpowers/systematic-debugging/scripts
mkdir -p skills/superpowers/subagent-driven-development
mkdir -p skills/superpowers/writing-skills
```

Expected: no output (all directories created)

- [ ] **Step 2: Create `tools/superpowers.py`**

Write the following content to `/Users/shubhan/superpowers-hermes/tools/superpowers.py`:

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

- [ ] **Step 3: Create `skills/superpowers/DESCRIPTION.md`**

Write the following content to `/Users/shubhan/superpowers-hermes/skills/superpowers/DESCRIPTION.md`:

```markdown
# Superpowers

Software development methodology skills ported from https://github.com/obra/superpowers
by Jesse Vincent. Provides structured, opinionated workflows for planning, TDD, debugging,
code review, subagent orchestration, and more.

Enable with: `hermes tools --enable superpowers`
```

- [ ] **Step 4: Verify files exist**

```bash
ls /Users/shubhan/superpowers-hermes/tools/superpowers.py
ls /Users/shubhan/superpowers-hermes/skills/superpowers/DESCRIPTION.md
ls /Users/shubhan/superpowers-hermes/skills/superpowers/
```

Expected: `superpowers.py` listed; `DESCRIPTION.md` listed; 14 skill directories listed.

- [ ] **Step 5: Commit**

```bash
cd /Users/shubhan/superpowers-hermes
git add tools/superpowers.py skills/superpowers/DESCRIPTION.md
git commit -m "feat: add toolset definition and skill directory structure"
```

---

### Task 2: Bootstrap Skill — `using-superpowers` + `hermes-tools.md`

**Files:**
- Create: `skills/superpowers/using-superpowers/SKILL.md`
- Create: `skills/superpowers/using-superpowers/references/hermes-tools.md`

**Source:** `~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/using-superpowers/SKILL.md`

- [ ] **Step 1: Read the upstream SKILL.md**

```bash
cat ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/using-superpowers/SKILL.md
```

Note the exact body content after the existing YAML frontmatter (everything after the closing `---` on line 4).

- [ ] **Step 2: Write `using-superpowers/SKILL.md`**

Write to `/Users/shubhan/superpowers-hermes/skills/superpowers/using-superpowers/SKILL.md` with:

**a) This YAML frontmatter** (no `requires_toolsets` — this skill is always injected):
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

**b) Immediately after the frontmatter**, this integration note section:
```markdown
## Hermes Integration Note

You are running in Hermes Agent. Skills are injected into this context automatically when
the `superpowers` toolset is active — you do not need to "invoke" them explicitly via a tool.
All other superpowers skills are already in your context.
See `references/hermes-tools.md` for the Claude Code → Hermes tool name mapping.

```

**c) Then the complete upstream body verbatim**, with this one substitution:
- Find any paragraph containing "Use the `Skill` tool" or instructions to invoke skills via the `Skill` tool
- Replace that paragraph with: `*(In Hermes, all superpowers skills are injected into your context automatically — no explicit invocation needed.)*`

- [ ] **Step 3: Write `hermes-tools.md`**

Write the following content to `/Users/shubhan/superpowers-hermes/skills/superpowers/using-superpowers/references/hermes-tools.md`:

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

- [ ] **Step 4: Verify**

```bash
head -15 /Users/shubhan/superpowers-hermes/skills/superpowers/using-superpowers/SKILL.md
cat /Users/shubhan/superpowers-hermes/skills/superpowers/using-superpowers/references/hermes-tools.md
```

Expected: YAML frontmatter with `name: using-superpowers` and NO `requires_toolsets`; hermes-tools.md shows the mapping table.

- [ ] **Step 5: Commit**

```bash
cd /Users/shubhan/superpowers-hermes
git add skills/superpowers/using-superpowers/
git commit -m "feat: add using-superpowers bootstrap skill and hermes-tools mapping"
```

---

### Task 3: Standard Port — Batch A (brainstorming, test-driven-development, writing-plans, executing-plans)

**Files:**
- Create: `skills/superpowers/brainstorming/SKILL.md`
- Create: `skills/superpowers/test-driven-development/SKILL.md`
- Create: `skills/superpowers/writing-plans/SKILL.md`
- Create: `skills/superpowers/executing-plans/SKILL.md`

**Source dir:** `~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/`

**Standard port procedure (apply to ALL 4 skills):**
1. Read the upstream `SKILL.md`
2. Strip the existing 4-line YAML frontmatter (`---` / `name:` / `description:` / `---`)
3. Prepend the new frontmatter below
4. In the body, replace any paragraph instructing to use the Skill tool for invocation with: `*(This skill is automatically injected into your context when the superpowers toolset is active.)*`
5. Keep everything else verbatim

- [ ] **Step 1: Read all 4 upstream SKILL.md files**

```bash
cat ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/brainstorming/SKILL.md
cat ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/test-driven-development/SKILL.md
cat ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/writing-plans/SKILL.md
cat ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/executing-plans/SKILL.md
```

- [ ] **Step 2: Write `brainstorming/SKILL.md`**

Prepend this frontmatter, then append the upstream body (lines after the upstream closing `---`):

```yaml
---
name: brainstorming
description: "You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements and design before implementation."
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

Write to: `/Users/shubhan/superpowers-hermes/skills/superpowers/brainstorming/SKILL.md`

- [ ] **Step 3: Write `test-driven-development/SKILL.md`**

Prepend this frontmatter, then append the upstream body:

```yaml
---
name: test-driven-development
description: Use when implementing any feature or bugfix, before writing implementation code
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

Write to: `/Users/shubhan/superpowers-hermes/skills/superpowers/test-driven-development/SKILL.md`

- [ ] **Step 4: Write `writing-plans/SKILL.md`**

Prepend this frontmatter, then append the upstream body:

```yaml
---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
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

Write to: `/Users/shubhan/superpowers-hermes/skills/superpowers/writing-plans/SKILL.md`

- [ ] **Step 5: Write `executing-plans/SKILL.md`**

Prepend this frontmatter, then append the upstream body:

```yaml
---
name: executing-plans
description: Use when you have a written implementation plan to execute in a separate session with review checkpoints
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

Write to: `/Users/shubhan/superpowers-hermes/skills/superpowers/executing-plans/SKILL.md`

- [ ] **Step 6: Verify frontmatter and requires_toolsets**

```bash
grep -A 15 "^---" /Users/shubhan/superpowers-hermes/skills/superpowers/brainstorming/SKILL.md | head -15
grep "requires_toolsets" /Users/shubhan/superpowers-hermes/skills/superpowers/brainstorming/SKILL.md
grep "requires_toolsets" /Users/shubhan/superpowers-hermes/skills/superpowers/test-driven-development/SKILL.md
grep "requires_toolsets" /Users/shubhan/superpowers-hermes/skills/superpowers/writing-plans/SKILL.md
grep "requires_toolsets" /Users/shubhan/superpowers-hermes/skills/superpowers/executing-plans/SKILL.md
```

Expected: each file contains `requires_toolsets: [superpowers]`

- [ ] **Step 7: Commit**

```bash
cd /Users/shubhan/superpowers-hermes
git add skills/superpowers/brainstorming/ skills/superpowers/test-driven-development/ skills/superpowers/writing-plans/ skills/superpowers/executing-plans/
git commit -m "feat: port brainstorming, test-driven-development, writing-plans, executing-plans skills"
```

---

### Task 4: Standard Port — Batch B (dispatching-parallel-agents, requesting-code-review, receiving-code-review, verification-before-completion)

**Files:**
- Create: `skills/superpowers/dispatching-parallel-agents/SKILL.md`
- Create: `skills/superpowers/requesting-code-review/SKILL.md`
- Create: `skills/superpowers/receiving-code-review/SKILL.md`
- Create: `skills/superpowers/verification-before-completion/SKILL.md`

**Standard port procedure:** same as Task 3 — read upstream, prepend new frontmatter, replace Skill-tool invocation paragraphs, keep body verbatim.

- [ ] **Step 1: Read all 4 upstream SKILL.md files**

```bash
cat ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/dispatching-parallel-agents/SKILL.md
cat ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/requesting-code-review/SKILL.md
cat ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/receiving-code-review/SKILL.md
cat ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/verification-before-completion/SKILL.md
```

- [ ] **Step 2: Write `dispatching-parallel-agents/SKILL.md`**

```yaml
---
name: dispatching-parallel-agents
description: Use when facing 2+ independent tasks that can be worked on without shared state or sequential dependencies
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

Write to: `/Users/shubhan/superpowers-hermes/skills/superpowers/dispatching-parallel-agents/SKILL.md`

- [ ] **Step 3: Write `requesting-code-review/SKILL.md`**

```yaml
---
name: requesting-code-review
description: Use when completing tasks, implementing major features, or before merging to verify work meets requirements
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

Write to: `/Users/shubhan/superpowers-hermes/skills/superpowers/requesting-code-review/SKILL.md`

- [ ] **Step 4: Write `receiving-code-review/SKILL.md`**

```yaml
---
name: receiving-code-review
description: Use when receiving code review feedback, before implementing suggestions, especially if feedback seems unclear or technically questionable - requires technical rigor and verification, not performative agreement or blind implementation
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

Write to: `/Users/shubhan/superpowers-hermes/skills/superpowers/receiving-code-review/SKILL.md`

- [ ] **Step 5: Write `verification-before-completion/SKILL.md`**

```yaml
---
name: verification-before-completion
description: Use when about to claim work is complete, fixed, or passing, before committing or creating PRs - requires running verification commands and confirming output before making any success claims; evidence before assertions always
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

Write to: `/Users/shubhan/superpowers-hermes/skills/superpowers/verification-before-completion/SKILL.md`

- [ ] **Step 6: Verify**

```bash
grep "requires_toolsets" \
  /Users/shubhan/superpowers-hermes/skills/superpowers/dispatching-parallel-agents/SKILL.md \
  /Users/shubhan/superpowers-hermes/skills/superpowers/requesting-code-review/SKILL.md \
  /Users/shubhan/superpowers-hermes/skills/superpowers/receiving-code-review/SKILL.md \
  /Users/shubhan/superpowers-hermes/skills/superpowers/verification-before-completion/SKILL.md
```

Expected: 4 lines, each containing `requires_toolsets: [superpowers]`

- [ ] **Step 7: Commit**

```bash
cd /Users/shubhan/superpowers-hermes
git add skills/superpowers/dispatching-parallel-agents/ skills/superpowers/requesting-code-review/ skills/superpowers/receiving-code-review/ skills/superpowers/verification-before-completion/
git commit -m "feat: port dispatching-parallel-agents, requesting-code-review, receiving-code-review, verification-before-completion skills"
```

---

### Task 5: Standard Port — Batch C (finishing-a-development-branch, using-git-worktrees)

**Files:**
- Create: `skills/superpowers/finishing-a-development-branch/SKILL.md`
- Create: `skills/superpowers/using-git-worktrees/SKILL.md`

- [ ] **Step 1: Read both upstream SKILL.md files**

```bash
cat ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/finishing-a-development-branch/SKILL.md
cat ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/using-git-worktrees/SKILL.md
```

- [ ] **Step 2: Write `finishing-a-development-branch/SKILL.md`**

```yaml
---
name: finishing-a-development-branch
description: Use when implementation is complete, all tests pass, and you need to decide how to integrate the work - guides completion of development work by presenting structured options for merge, PR, or cleanup
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

Write to: `/Users/shubhan/superpowers-hermes/skills/superpowers/finishing-a-development-branch/SKILL.md`

- [ ] **Step 3: Write `using-git-worktrees/SKILL.md`**

```yaml
---
name: using-git-worktrees
description: Use when starting feature work that needs isolation from current workspace or before executing implementation plans - ensures an isolated workspace exists via native tools or git worktree fallback
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

Write to: `/Users/shubhan/superpowers-hermes/skills/superpowers/using-git-worktrees/SKILL.md`

- [ ] **Step 4: Verify**

```bash
grep "requires_toolsets" \
  /Users/shubhan/superpowers-hermes/skills/superpowers/finishing-a-development-branch/SKILL.md \
  /Users/shubhan/superpowers-hermes/skills/superpowers/using-git-worktrees/SKILL.md
wc -l /Users/shubhan/superpowers-hermes/skills/superpowers/finishing-a-development-branch/SKILL.md
wc -l /Users/shubhan/superpowers-hermes/skills/superpowers/using-git-worktrees/SKILL.md
```

Expected: 2 `requires_toolsets` lines; line counts should be close to upstream (~251 and ~215 lines respectively, plus the new frontmatter lines)

- [ ] **Step 5: Commit**

```bash
cd /Users/shubhan/superpowers-hermes
git add skills/superpowers/finishing-a-development-branch/ skills/superpowers/using-git-worktrees/
git commit -m "feat: port finishing-a-development-branch and using-git-worktrees skills"
```

---

### Task 6: systematic-debugging + Helper Script

**Files:**
- Create: `skills/superpowers/systematic-debugging/SKILL.md`
- Copy: `skills/superpowers/systematic-debugging/scripts/find-polluter.sh`

- [ ] **Step 1: Read upstream SKILL.md**

```bash
cat ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/systematic-debugging/SKILL.md
```

- [ ] **Step 2: Write `systematic-debugging/SKILL.md`**

```yaml
---
name: systematic-debugging
description: Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes
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

Write to: `/Users/shubhan/superpowers-hermes/skills/superpowers/systematic-debugging/SKILL.md`

Append the full upstream body after the frontmatter. Replace any Skill-tool invocation paragraph with: `*(This skill is automatically injected into your context when the superpowers toolset is active.)*`

- [ ] **Step 3: Copy find-polluter.sh verbatim**

```bash
cp ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/systematic-debugging/find-polluter.sh \
   /Users/shubhan/superpowers-hermes/skills/superpowers/systematic-debugging/scripts/find-polluter.sh
```

- [ ] **Step 4: Make script executable**

```bash
chmod +x /Users/shubhan/superpowers-hermes/skills/superpowers/systematic-debugging/scripts/find-polluter.sh
```

- [ ] **Step 5: Verify**

```bash
grep "requires_toolsets" /Users/shubhan/superpowers-hermes/skills/superpowers/systematic-debugging/SKILL.md
ls -la /Users/shubhan/superpowers-hermes/skills/superpowers/systematic-debugging/scripts/find-polluter.sh
head -5 /Users/shubhan/superpowers-hermes/skills/superpowers/systematic-debugging/scripts/find-polluter.sh
```

Expected: `requires_toolsets: [superpowers]`; file is executable (-rwxr-xr-x); first lines match upstream script header

- [ ] **Step 6: Commit**

```bash
cd /Users/shubhan/superpowers-hermes
git add skills/superpowers/systematic-debugging/
git commit -m "feat: port systematic-debugging skill and copy find-polluter.sh helper"
```

---

### Task 7: subagent-driven-development + Helper Files

**Files:**
- Create: `skills/superpowers/subagent-driven-development/SKILL.md`
- Copy: `skills/superpowers/subagent-driven-development/implementer-prompt.md`
- Copy: `skills/superpowers/subagent-driven-development/code-quality-reviewer-prompt.md`

- [ ] **Step 1: Read upstream SKILL.md**

```bash
cat ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/subagent-driven-development/SKILL.md
```

- [ ] **Step 2: Write `subagent-driven-development/SKILL.md`**

```yaml
---
name: subagent-driven-development
description: Use when executing implementation plans with independent tasks in the current session
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

Write to: `/Users/shubhan/superpowers-hermes/skills/superpowers/subagent-driven-development/SKILL.md`

Append full upstream body. Replace Skill-tool invocation paragraphs with: `*(This skill is automatically injected into your context when the superpowers toolset is active.)*`

- [ ] **Step 3: Copy helper files verbatim**

```bash
cp ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/subagent-driven-development/implementer-prompt.md \
   /Users/shubhan/superpowers-hermes/skills/superpowers/subagent-driven-development/implementer-prompt.md

cp ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/subagent-driven-development/code-quality-reviewer-prompt.md \
   /Users/shubhan/superpowers-hermes/skills/superpowers/subagent-driven-development/code-quality-reviewer-prompt.md
```

- [ ] **Step 4: Verify**

```bash
grep "requires_toolsets" /Users/shubhan/superpowers-hermes/skills/superpowers/subagent-driven-development/SKILL.md
diff ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/subagent-driven-development/implementer-prompt.md \
     /Users/shubhan/superpowers-hermes/skills/superpowers/subagent-driven-development/implementer-prompt.md
diff ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/subagent-driven-development/code-quality-reviewer-prompt.md \
     /Users/shubhan/superpowers-hermes/skills/superpowers/subagent-driven-development/code-quality-reviewer-prompt.md
```

Expected: `requires_toolsets: [superpowers]`; both diffs produce no output (files identical)

- [ ] **Step 5: Commit**

```bash
cd /Users/shubhan/superpowers-hermes
git add skills/superpowers/subagent-driven-development/
git commit -m "feat: port subagent-driven-development skill and copy implementer/reviewer prompt files"
```

---

### Task 8: writing-skills (Hermes-Adapted Port)

**Files:**
- Create: `skills/superpowers/writing-skills/SKILL.md`

This skill requires special adaptation: the Directory Structure section and Skill Creation Checklist's Deployment subsection must be rewritten for Hermes format. All TDD methodology content stays verbatim.

- [ ] **Step 1: Read the full upstream SKILL.md**

```bash
cat ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/writing-skills/SKILL.md
```

Identify these sections in the upstream file:
- `## Directory Structure` (line ~72): describes `skills/skill-name/SKILL.md` with flat namespace
- `## SKILL.md Structure` (line ~93): frontmatter says only `name` and `description` required
- `**Deployment:**` subsection in the Skill Creation Checklist (line ~631): says "Commit skill to git and push to your fork"

- [ ] **Step 2: Write `writing-skills/SKILL.md`**

Write to `/Users/shubhan/superpowers-hermes/skills/superpowers/writing-skills/SKILL.md`:

**Frontmatter:**
```yaml
---
name: writing-skills
description: Use when creating new skills, editing existing skills, or verifying skills work before deployment
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

**Then the full upstream body**, with these three targeted replacements:

**Replacement A — Directory Structure section** (replace the content of `## Directory Structure`):

Replace:
```
## Directory Structure


```
skills/
  skill-name/
    SKILL.md              # Main reference (required)
    supporting-file.*     # Only if needed
```

**Flat namespace** - all skills in one searchable namespace
```

With:
```markdown
## Directory Structure

```
skills/
  <category>/
    <skill-name>/
      SKILL.md              # Main reference (required)
      supporting-file.*     # Only if needed
```

**Category namespace** — skills are grouped by category (e.g. `superpowers`, `myproject`).
Place skills at: `skills/<category>/<skill-name>/SKILL.md`
```

**Replacement B — SKILL.md Structure frontmatter description** (update the required fields list):

Replace:
```
- Two required fields: `name` and `description` (see [agentskills.io/specification](https://agentskills.io/specification) for all supported fields)
```

With:
```
- Required fields: `name`, `description`, `version`, `author`, `license`
- Hermes metadata block: `metadata.hermes.tags`, `metadata.hermes.related_skills`, `metadata.hermes.requires_toolsets`
- Example frontmatter:
  ```yaml
  ---
  name: my-skill
  description: Use when...
  version: 1.0.0
  author: Your Name
  license: MIT
  metadata:
    hermes:
      tags: [Development]
      related_skills: [using-superpowers]
      requires_toolsets: [my-toolset]
  ---
  ```
```

**Replacement C — Deployment checklist** (replace the two lines under `**Deployment:**`):

Replace:
```
- [ ] Commit skill to git and push to your fork (if configured)
- [ ] Consider contributing back via PR (if broadly useful)
```

With:
```
- [ ] Place skill at `skills/<category>/<skill-name>/SKILL.md` in your project
- [ ] Run `./install.sh` to copy to `~/.hermes/skills/` OR copy manually: `cp -r skills/<category> ~/.hermes/skills/`
- [ ] Enable the toolset: `hermes tools --enable <toolset-name>`
- [ ] Test: start a Hermes session and verify the skill content appears in context
- [ ] Consider contributing back via PR to the upstream repo (if broadly useful)
```

Replace any Skill-tool invocation paragraph with: `*(This skill is automatically injected into your context when the superpowers toolset is active.)*`

- [ ] **Step 3: Verify**

```bash
grep "requires_toolsets" /Users/shubhan/superpowers-hermes/skills/superpowers/writing-skills/SKILL.md
grep -c "install.sh" /Users/shubhan/superpowers-hermes/skills/superpowers/writing-skills/SKILL.md
wc -l /Users/shubhan/superpowers-hermes/skills/superpowers/writing-skills/SKILL.md
```

Expected: `requires_toolsets: [superpowers]` present; at least 1 occurrence of `install.sh`; line count ≥ 655 (same as upstream plus new frontmatter and added content)

- [ ] **Step 4: Commit**

```bash
cd /Users/shubhan/superpowers-hermes
git add skills/superpowers/writing-skills/
git commit -m "feat: port writing-skills with Hermes directory structure and install section"
```

---

### Task 9: install.sh + README.md

**Files:**
- Create: `install.sh`
- Create: `README.md`

- [ ] **Step 1: Write `install.sh`**

Write to `/Users/shubhan/superpowers-hermes/install.sh`:

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

- [ ] **Step 2: Make install.sh executable**

```bash
chmod +x /Users/shubhan/superpowers-hermes/install.sh
```

- [ ] **Step 3: Write `README.md`**

Write to `/Users/shubhan/superpowers-hermes/README.md`:

```markdown
# superpowers-hermes

A port of the [Superpowers](https://github.com/obra/superpowers) software development methodology skills (v5.1.0) by Jesse Vincent to [Hermes Agent](https://github.com/NousResearch/hermes) by NousResearch. Brings structured, opinionated workflows for planning, TDD, debugging, code review, and subagent orchestration into Hermes's native skill injection system.

## Prerequisites

- Hermes Agent installed (`pip install hermes-agent` or see the [Hermes repo](https://github.com/NousResearch/hermes) for setup)

## Installation

```bash
git clone https://github.com/yourusername/superpowers-hermes
cd superpowers-hermes
./install.sh
hermes tools --enable superpowers
```

## Acceptance Test

In a Hermes session, send: **"Let's make a React todo list"**

The `brainstorming` skill should trigger before any code is written — you should see it asking clarifying questions about requirements and presenting a design for approval before touching implementation.

## Skills Included

| Skill | Description |
|---|---|
| `using-superpowers` | Bootstrap — establishes methodology, always active |
| `brainstorming` | Explore intent and design before implementation |
| `test-driven-development` | RED-GREEN-REFACTOR cycle enforcement |
| `writing-plans` | Convert specs into bite-sized task plans |
| `executing-plans` | Execute plans with session-boundary review checkpoints |
| `subagent-driven-development` | Dispatch fresh subagents per task |
| `dispatching-parallel-agents` | Parallelize independent tasks |
| `systematic-debugging` | Structured root-cause analysis before fixing |
| `requesting-code-review` | Pre-merge verification workflow |
| `receiving-code-review` | Rigorous, non-performative review response |
| `verification-before-completion` | Evidence-based completion claims |
| `finishing-a-development-branch` | Integration decision workflow |
| `using-git-worktrees` | Isolated workspace management |
| `writing-skills` | TDD-adapted skill authoring for Hermes |

## Notes

- The `brainstorming` skill references a visual companion server available in the upstream repo's `skills/brainstorming/scripts/` — not ported here. See [https://github.com/obra/superpowers](https://github.com/obra/superpowers) for it.
- Source: upstream repo [https://github.com/obra/superpowers](https://github.com/obra/superpowers) (v5.1.0), MIT license.

## License

MIT
```

- [ ] **Step 4: Verify install.sh is executable**

```bash
ls -la /Users/shubhan/superpowers-hermes/install.sh
head -5 /Users/shubhan/superpowers-hermes/install.sh
```

Expected: `-rwxr-xr-x` permissions; first line is `#!/usr/bin/env bash`

- [ ] **Step 5: Commit**

```bash
cd /Users/shubhan/superpowers-hermes
git add install.sh README.md
git commit -m "feat: add install.sh and README.md"
```

---

### Task 10: Final Verification

- [ ] **Step 1: Count skill directories**

```bash
ls /Users/shubhan/superpowers-hermes/skills/superpowers/ | wc -l
ls /Users/shubhan/superpowers-hermes/skills/superpowers/
```

Expected: exactly 14 directories

- [ ] **Step 2: Verify all non-bootstrap skills have requires_toolsets**

```bash
for skill in brainstorming systematic-debugging test-driven-development writing-plans executing-plans subagent-driven-development dispatching-parallel-agents requesting-code-review receiving-code-review finishing-a-development-branch using-git-worktrees verification-before-completion writing-skills; do
  echo -n "$skill: "
  grep "requires_toolsets" /Users/shubhan/superpowers-hermes/skills/superpowers/$skill/SKILL.md || echo "MISSING"
done
```

Expected: 13 lines each showing `requires_toolsets: [superpowers]`

- [ ] **Step 3: Verify using-superpowers has NO requires_toolsets**

```bash
grep "requires_toolsets" /Users/shubhan/superpowers-hermes/skills/superpowers/using-superpowers/SKILL.md && echo "FAIL: should not have requires_toolsets" || echo "PASS: no requires_toolsets found"
```

Expected: `PASS: no requires_toolsets found`

- [ ] **Step 4: Verify tools/superpowers.py exists and has registry.register**

```bash
grep "registry.register" /Users/shubhan/superpowers-hermes/tools/superpowers.py
```

Expected: one line containing `registry.register(`

- [ ] **Step 5: Verify install.sh is executable**

```bash
test -x /Users/shubhan/superpowers-hermes/install.sh && echo "PASS: executable" || echo "FAIL: not executable"
```

Expected: `PASS: executable`

- [ ] **Step 6: Verify hermes-tools.md exists**

```bash
cat /Users/shubhan/superpowers-hermes/skills/superpowers/using-superpowers/references/hermes-tools.md
```

Expected: file exists and shows the tool mapping table

- [ ] **Step 7: Verify helper files are present and identical to upstream**

```bash
diff ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/systematic-debugging/find-polluter.sh \
     /Users/shubhan/superpowers-hermes/skills/superpowers/systematic-debugging/scripts/find-polluter.sh
diff ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/subagent-driven-development/implementer-prompt.md \
     /Users/shubhan/superpowers-hermes/skills/superpowers/subagent-driven-development/implementer-prompt.md
diff ~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/subagent-driven-development/code-quality-reviewer-prompt.md \
     /Users/shubhan/superpowers-hermes/skills/superpowers/subagent-driven-development/code-quality-reviewer-prompt.md
```

Expected: all three diffs produce no output

- [ ] **Step 8: Final git status check**

```bash
cd /Users/shubhan/superpowers-hermes && git log --oneline
git status
```

Expected: clean working tree; git log shows commits for each task; 8+ commits total

---

## Spec Coverage Self-Review

| Requirement | Task |
|---|---|
| `tools/superpowers.py` with `registry.register` | Task 1 |
| All 14 skill dirs created | Tasks 1–8 |
| `using-superpowers` YAML: no `requires_toolsets`, Hermes integration note prepended | Task 2 |
| All other 13 skills: `requires_toolsets: [superpowers]` | Tasks 3–8 |
| Skill body Skill-tool invocations replaced | Tasks 2–8 |
| `hermes-tools.md` reference file | Task 2 |
| `DESCRIPTION.md` | Task 1 |
| `find-polluter.sh` copied verbatim + executable | Task 6 |
| `implementer-prompt.md` + `code-quality-reviewer-prompt.md` copied verbatim | Task 7 |
| `writing-skills` adapted for Hermes install/structure | Task 8 |
| `install.sh` executable | Task 9 |
| `README.md` with acceptance test + notes | Task 9 |
| Git commits at each task | Tasks 1–9 |
| Verification checklist run | Task 10 |
