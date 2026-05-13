# Superpowers-Hermes Plugin Fix Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix the broken `tools/superpowers.py` toolset registration by replacing it with a proper hermes user plugin (`plugin/`) so `requires_toolsets: [superpowers]` activates correctly, and port missing upstream reference files with `${HERMES_SKILL_DIR}` paths.

**Architecture:** A `plugin/` directory (installed to `~/.hermes/plugins/superpowers/`) contains `plugin.yaml` and `__init__.py`. The `register(ctx)` function calls `ctx.register_tool(..., toolset="superpowers")` — the correct hermes plugin API. The old `tools/superpowers.py` (which tried to import from inside the hermes source package) is deleted. Missing upstream reference files for `systematic-debugging` and `subagent-driven-development` are copied and their SKILL.md files updated to use `${HERMES_SKILL_DIR}` absolute path tokens.

**Tech Stack:** Python 3.11, hermes-agent plugin API (`PluginContext.register_tool`), YAML, Bash, hermes `plugins.enabled` config.

---

## File Map

**Create:**
- `plugin/plugin.yaml` — hermes user plugin manifest
- `plugin/__init__.py` — plugin entry point with `register(ctx)` using correct API
- `skills/superpowers/systematic-debugging/root-cause-tracing.md` — copy from upstream
- `skills/superpowers/systematic-debugging/condition-based-waiting.md` — copy from upstream
- `skills/superpowers/systematic-debugging/defense-in-depth.md` — copy from upstream
- `skills/superpowers/systematic-debugging/test-academic.md` — copy from upstream
- `skills/superpowers/systematic-debugging/test-pressure-1.md` — copy from upstream
- `skills/superpowers/systematic-debugging/test-pressure-2.md` — copy from upstream
- `skills/superpowers/systematic-debugging/test-pressure-3.md` — copy from upstream
- `skills/superpowers/systematic-debugging/scripts/condition-based-waiting-example.ts` — copy from upstream
- `skills/superpowers/subagent-driven-development/spec-reviewer-prompt.md` — copy from upstream

**Modify:**
- `skills/superpowers/systematic-debugging/SKILL.md` — replace `root-cause-tracing.md` references with `${HERMES_SKILL_DIR}/root-cause-tracing.md`
- `skills/superpowers/subagent-driven-development/SKILL.md` — replace `./implementer-prompt.md` / `./spec-reviewer-prompt.md` / `./code-quality-reviewer-prompt.md` with `${HERMES_SKILL_DIR}/` equivalents
- `install.sh` — replace `cp tools/superpowers.py "$HERMES_DIR/tools/"` with `cp -r plugin "$HERMES_DIR/plugins/superpowers"`, update enable command
- `README.md` — change `hermes tools --enable superpowers` → `hermes plugins enable superpowers`

**Delete:**
- `tools/superpowers.py`
- `tools/` directory (now empty)

---

### Task 1: Create `plugin/` directory — the core fix

**Files:**
- Create: `plugin/plugin.yaml`
- Create: `plugin/__init__.py`
- Delete: `tools/superpowers.py`

**Context:** hermes loads user plugins from `~/.hermes/plugins/<name>/`. Each plugin needs `plugin.yaml` (manifest) and `__init__.py` (with a `register(ctx)` function). `ctx.register_tool(name, toolset=..., schema, handler)` is the correct API — confirmed from `hermes_cli/plugins.py:317`. The old `from tools.registry import registry` import in `tools/superpowers.py` only works inside the hermes source tree, not when the file is copied externally.

- [ ] **Step 1: Create `plugin/` directory**

```bash
mkdir -p /home/shubhan/superpowers-hermes/plugin
```

Expected: no output (directory created)

- [ ] **Step 2: Write `plugin/plugin.yaml`**

Write to `/home/shubhan/superpowers-hermes/plugin/plugin.yaml`:

```yaml
name: superpowers
version: 5.1.0
description: "Superpowers methodology skills — structured workflows for planning, TDD, debugging, code review, and subagent orchestration (ported from Jesse Vincent's superpowers v5.1.0)"
```

- [ ] **Step 3: Write `plugin/__init__.py`**

Write to `/home/shubhan/superpowers-hermes/plugin/__init__.py`:

```python
_SCHEMA = {
    "type": "object",
    "properties": {
        "query": {"type": "string", "description": "Skill name to describe"}
    },
    "required": [],
}


def _handle(args, **kwargs):
    return "Superpowers methodology skills are active and injected into your context."


def register(ctx):
    """Register the superpowers toolset via the hermes plugin API."""
    ctx.register_tool(
        name="superpowers_active",
        toolset="superpowers",
        schema=_SCHEMA,
        handler=_handle,
        description="Confirms superpowers methodology skills are active",
        emoji="⚡",
    )
```

- [ ] **Step 4: Delete `tools/superpowers.py` and `tools/` directory**

```bash
rm -rf /home/shubhan/superpowers-hermes/tools
```

Expected: no output

- [ ] **Step 5: Verify `plugin/` contents**

```bash
ls /home/shubhan/superpowers-hermes/plugin/
cat /home/shubhan/superpowers-hermes/plugin/plugin.yaml
head -5 /home/shubhan/superpowers-hermes/plugin/__init__.py
```

Expected:
```
__init__.py  plugin.yaml
name: superpowers
...
def register(ctx):
```

- [ ] **Step 6: Commit**

```bash
cd /home/shubhan/superpowers-hermes
git add plugin/
git rm -r tools/
git commit -m "fix: replace tools/superpowers.py with proper hermes user plugin in plugin/"
```

---

### Task 2: Port missing systematic-debugging reference files

**Files:**
- Create: `skills/superpowers/systematic-debugging/root-cause-tracing.md`
- Create: `skills/superpowers/systematic-debugging/condition-based-waiting.md`
- Create: `skills/superpowers/systematic-debugging/defense-in-depth.md`
- Create: `skills/superpowers/systematic-debugging/test-academic.md`
- Create: `skills/superpowers/systematic-debugging/test-pressure-1.md`
- Create: `skills/superpowers/systematic-debugging/test-pressure-2.md`
- Create: `skills/superpowers/systematic-debugging/test-pressure-3.md`
- Create: `skills/superpowers/systematic-debugging/scripts/condition-based-waiting-example.ts`

**Context:** The upstream `systematic-debugging` skill at `~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/systematic-debugging/` has 10 files. The port only copied `SKILL.md` and `find-polluter.sh`. The SKILL.md body references `root-cause-tracing.md` at lines 122 and 290 — it's missing, so the agent can't use it.

- [ ] **Step 1: Copy all missing upstream files**

```bash
UPSTREAM=~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/systematic-debugging
DEST=/home/shubhan/superpowers-hermes/skills/superpowers/systematic-debugging

cp "$UPSTREAM/root-cause-tracing.md" "$DEST/"
cp "$UPSTREAM/condition-based-waiting.md" "$DEST/"
cp "$UPSTREAM/defense-in-depth.md" "$DEST/"
cp "$UPSTREAM/test-academic.md" "$DEST/"
cp "$UPSTREAM/test-pressure-1.md" "$DEST/"
cp "$UPSTREAM/test-pressure-2.md" "$DEST/"
cp "$UPSTREAM/test-pressure-3.md" "$DEST/"
cp "$UPSTREAM/condition-based-waiting-example.ts" "$DEST/scripts/"
```

Expected: no output (files copied)

- [ ] **Step 2: Verify all files present**

```bash
ls /home/shubhan/superpowers-hermes/skills/superpowers/systematic-debugging/
ls /home/shubhan/superpowers-hermes/skills/superpowers/systematic-debugging/scripts/
```

Expected:
```
SKILL.md  condition-based-waiting.md  defense-in-depth.md  root-cause-tracing.md
test-academic.md  test-pressure-1.md  test-pressure-2.md  test-pressure-3.md  scripts/

condition-based-waiting-example.ts  find-polluter.sh
```

- [ ] **Step 3: Commit**

```bash
cd /home/shubhan/superpowers-hermes
git add skills/superpowers/systematic-debugging/
git commit -m "fix: port missing systematic-debugging reference files from upstream"
```

---

### Task 3: Port missing subagent-driven-development `spec-reviewer-prompt.md`

**Files:**
- Create: `skills/superpowers/subagent-driven-development/spec-reviewer-prompt.md`

**Context:** The SKILL.md flowchart references `./spec-reviewer-prompt.md` but it was not copied in the original port. The upstream file is at `~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/subagent-driven-development/spec-reviewer-prompt.md`.

- [ ] **Step 1: Copy the missing file**

```bash
UPSTREAM=~/.claude/plugins/cache/claude-plugins-official/superpowers/5.1.0/skills/subagent-driven-development
cp "$UPSTREAM/spec-reviewer-prompt.md" /home/shubhan/superpowers-hermes/skills/superpowers/subagent-driven-development/
```

Expected: no output

- [ ] **Step 2: Verify**

```bash
ls /home/shubhan/superpowers-hermes/skills/superpowers/subagent-driven-development/
```

Expected: all four files present:
```
SKILL.md  code-quality-reviewer-prompt.md  implementer-prompt.md  spec-reviewer-prompt.md
```

- [ ] **Step 3: Commit**

```bash
cd /home/shubhan/superpowers-hermes
git add skills/superpowers/subagent-driven-development/spec-reviewer-prompt.md
git commit -m "fix: add missing spec-reviewer-prompt.md for subagent-driven-development"
```

---

### Task 4: Update `systematic-debugging/SKILL.md` with `${HERMES_SKILL_DIR}` references

**Files:**
- Modify: `skills/superpowers/systematic-debugging/SKILL.md`

**Context:** The SKILL.md references `root-cause-tracing.md in this directory` (line 122) and `**root-cause-tracing.md**` (line 290). Hermes substitutes `${HERMES_SKILL_DIR}` with the absolute skill directory path at load time, enabling the agent to locate bundled files. Without this, the agent sees a bare filename with no path context.

- [ ] **Step 1: Read current content at the two reference lines**

```bash
sed -n '118,126p' /home/shubhan/superpowers-hermes/skills/superpowers/systematic-debugging/SKILL.md
sed -n '286,294p' /home/shubhan/superpowers-hermes/skills/superpowers/systematic-debugging/SKILL.md
```

Expected line 122:
```
   See `root-cause-tracing.md` in this directory for the complete backward tracing technique.
```
Expected line 290:
```
- **`root-cause-tracing.md`** - Trace bugs backward through call stack to find original trigger
```

- [ ] **Step 2: Apply the two replacements**

In `/home/shubhan/superpowers-hermes/skills/superpowers/systematic-debugging/SKILL.md`:

Replace:
```
   See `root-cause-tracing.md` in this directory for the complete backward tracing technique.
```
With:
```
   See `${HERMES_SKILL_DIR}/root-cause-tracing.md` for the complete backward tracing technique.
```

Replace:
```
- **`root-cause-tracing.md`** - Trace bugs backward through call stack to find original trigger
```
With:
```
- **`${HERMES_SKILL_DIR}/root-cause-tracing.md`** - Trace bugs backward through call stack to find original trigger
```

- [ ] **Step 3: Verify the replacements**

```bash
grep 'HERMES_SKILL_DIR' /home/shubhan/superpowers-hermes/skills/superpowers/systematic-debugging/SKILL.md
```

Expected: exactly 2 lines containing `${HERMES_SKILL_DIR}`.

- [ ] **Step 4: Commit**

```bash
cd /home/shubhan/superpowers-hermes
git add skills/superpowers/systematic-debugging/SKILL.md
git commit -m "fix: use \${HERMES_SKILL_DIR} for root-cause-tracing.md references in systematic-debugging"
```

---

### Task 5: Update `subagent-driven-development/SKILL.md` with `${HERMES_SKILL_DIR}` references

**Files:**
- Modify: `skills/superpowers/subagent-driven-development/SKILL.md`

**Context:** The SKILL.md uses `./implementer-prompt.md`, `./spec-reviewer-prompt.md`, and `./code-quality-reviewer-prompt.md` as relative paths. In Hermes, `${HERMES_SKILL_DIR}` must be used so the agent receives an absolute path in the substituted system prompt. The `./` references occur both inside the dot-digraph diagram labels (purely visual) and in prose instructions that the agent acts on.

- [ ] **Step 1: Count occurrences of `./` prompt references**

```bash
grep -n '\./implementer-prompt\|\./spec-reviewer-prompt\|\./code-quality-reviewer-prompt' \
  /home/shubhan/superpowers-hermes/skills/superpowers/subagent-driven-development/SKILL.md
```

Note the line numbers — you will replace ALL occurrences.

- [ ] **Step 2: Apply replacements (replace_all)**

In `/home/shubhan/superpowers-hermes/skills/superpowers/subagent-driven-development/SKILL.md`:

Replace all occurrences of `./implementer-prompt.md` with `${HERMES_SKILL_DIR}/implementer-prompt.md`

Replace all occurrences of `./spec-reviewer-prompt.md` with `${HERMES_SKILL_DIR}/spec-reviewer-prompt.md`

Replace all occurrences of `./code-quality-reviewer-prompt.md` with `${HERMES_SKILL_DIR}/code-quality-reviewer-prompt.md`

- [ ] **Step 3: Verify replacements**

```bash
grep -c 'HERMES_SKILL_DIR' /home/shubhan/superpowers-hermes/skills/superpowers/subagent-driven-development/SKILL.md
grep '\./implementer\|\./spec-reviewer\|\./code-quality' /home/shubhan/superpowers-hermes/skills/superpowers/subagent-driven-development/SKILL.md
```

Expected: non-zero count from first command; zero lines from second (no bare `./` references remain).

- [ ] **Step 4: Commit**

```bash
cd /home/shubhan/superpowers-hermes
git add skills/superpowers/subagent-driven-development/SKILL.md
git commit -m "fix: use \${HERMES_SKILL_DIR} for prompt file references in subagent-driven-development"
```

---

### Task 6: Update `install.sh` and `README.md`

**Files:**
- Modify: `install.sh`
- Modify: `README.md`

**Context:** `install.sh` currently tries to copy `tools/superpowers.py` to `$HERMES_DIR/tools/` — that directory and file no longer exist. Replace with copying `plugin/` to `$HERMES_DIR/plugins/superpowers`. Update the README enable command from `hermes tools --enable superpowers` to `hermes plugins enable superpowers`. User plugins in `~/.hermes/plugins/` are opt-in: they require `plugins.enabled` in `config.yaml`, set by running `hermes plugins enable superpowers`.

- [ ] **Step 1: Read current `install.sh`**

```bash
cat /home/shubhan/superpowers-hermes/install.sh
```

Confirm it contains:
```bash
cp tools/superpowers.py "$HERMES_DIR/tools/"
echo "✓ Installed toolset → $HERMES_DIR/tools/superpowers.py"

echo ""
echo "Run: hermes tools --enable superpowers"
```

- [ ] **Step 2: Update `install.sh`**

In `/home/shubhan/superpowers-hermes/install.sh`:

Replace:
```bash
cp -r skills/superpowers "$HERMES_DIR/skills/"
echo "✓ Installed skills → $HERMES_DIR/skills/superpowers/"

cp tools/superpowers.py "$HERMES_DIR/tools/"
echo "✓ Installed toolset → $HERMES_DIR/tools/superpowers.py"

echo ""
echo "Run: hermes tools --enable superpowers"
```

With:
```bash
cp -r skills/superpowers "$HERMES_DIR/skills/"
echo "✓ Installed skills → $HERMES_DIR/skills/superpowers/"

mkdir -p "$HERMES_DIR/plugins"
cp -r plugin "$HERMES_DIR/plugins/superpowers"
echo "✓ Installed plugin → $HERMES_DIR/plugins/superpowers/"

echo ""
echo "Run: hermes plugins enable superpowers"
```

- [ ] **Step 3: Update `README.md` Installation section**

In `/home/shubhan/superpowers-hermes/README.md`:

Replace:
```bash
hermes tools --enable superpowers
```
With:
```bash
hermes plugins enable superpowers
```

- [ ] **Step 4: Verify**

```bash
grep 'plugins' /home/shubhan/superpowers-hermes/install.sh
grep 'plugins' /home/shubhan/superpowers-hermes/README.md
grep 'tools' /home/shubhan/superpowers-hermes/install.sh
```

Expected: `install.sh` has `plugins/superpowers` and no `tools/` references; `README.md` has `hermes plugins enable superpowers`.

- [ ] **Step 5: Commit**

```bash
cd /home/shubhan/superpowers-hermes
git add install.sh README.md
git commit -m "fix: update install.sh to use hermes plugin API; update README enable command"
```

---

### Task 7: Run `install.sh` and verify plugin loads

**Context:** All changes are now in place. Run the installer to deploy to `~/.hermes/`, enable the plugin, then verify it appears in `hermes plugins list` and that the `superpowers` toolset is recognized.

- [ ] **Step 1: Run the installer**

```bash
cd /home/shubhan/superpowers-hermes
./install.sh
```

Expected:
```
✓ Installed skills → /home/shubhan/.hermes/skills/superpowers/
✓ Installed plugin → /home/shubhan/.hermes/plugins/superpowers/
```

- [ ] **Step 2: Verify files installed**

```bash
ls /home/shubhan/.hermes/plugins/superpowers/
ls /home/shubhan/.hermes/skills/superpowers/ | head -5
```

Expected:
```
__init__.py  plugin.yaml
brainstorming  dispatching-parallel-agents  executing-plans  ...
```

- [ ] **Step 3: Enable the plugin**

```bash
cd /home/shubhan/.hermes/hermes-agent && python -m hermes plugins enable superpowers
```

Or if `hermes` is on PATH:
```bash
hermes plugins enable superpowers
```

Expected: confirmation message that `superpowers` was added to `plugins.enabled`.

- [ ] **Step 4: Verify the plugin is listed**

```bash
hermes plugins list
```

Expected: `superpowers` appears with `enabled` status and `⚡ superpowers_active` tool listed.

- [ ] **Step 5: Smoke-test skill injection**

```bash
hermes chat --toolsets superpowers -q "List all active superpowers skills"
```

Expected: the agent lists the 14 skills from `skills/superpowers/` — confirming `requires_toolsets: [superpowers]` gating activated.

- [ ] **Step 6: Commit final verification note**

No code changes in this step. If Step 5 passes, the feature is complete.

---

## Acceptance Criteria

- `hermes plugins list` shows `superpowers` as enabled
- `skills/superpowers/systematic-debugging/root-cause-tracing.md` exists
- `skills/superpowers/subagent-driven-development/spec-reviewer-prompt.md` exists
- `grep HERMES_SKILL_DIR skills/superpowers/systematic-debugging/SKILL.md` returns 2 lines
- `grep HERMES_SKILL_DIR skills/superpowers/subagent-driven-development/SKILL.md` returns non-zero
- `install.sh` references `plugins/superpowers`, not `tools/`
- `tools/` directory is gone

---

## Spec Coverage Self-Review

| Requirement | Task |
|---|---|
| Fix broken toolset registration | Task 1 — replace tools/ with plugin/ |
| Correct `register(ctx)` API | Task 1 — `ctx.register_tool(..., toolset="superpowers")` |
| Port missing systematic-debugging files | Task 2 |
| Port missing spec-reviewer-prompt.md | Task 3 |
| Add `${HERMES_SKILL_DIR}` to systematic-debugging | Task 4 |
| Add `${HERMES_SKILL_DIR}` to subagent-driven-development | Task 5 |
| Update install.sh | Task 6 |
| End-to-end verification | Task 7 |
