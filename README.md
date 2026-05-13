# superpowers-hermes

A port of the [Superpowers](https://github.com/obra/superpowers) software development methodology skills (v5.1.0) by Jesse Vincent to [Hermes Agent](https://github.com/NousResearch/hermes) by NousResearch. Brings structured, opinionated workflows for planning, TDD, debugging, code review, and subagent orchestration into Hermes's native skill injection system.

## Prerequisites

- Hermes Agent installed (`pip install hermes-agent` or see the [Hermes repo](https://github.com/NousResearch/hermes) for setup)

## Installation

```bash
git clone https://github.com/yourusername/superpowers-hermes
cd superpowers-hermes
./install.sh
hermes plugins enable superpowers
```

## Activating in a Hermes Agent

`hermes plugins enable superpowers` registers the plugin but does **not** automatically inject the skills. Each skill has `requires_toolsets: [superpowers]` in its frontmatter, so the `superpowers` toolset must be active in the session for skills to trigger.

**One-off session (CLI):**
```bash
hermes chat --toolsets superpowers
```

**All CLI sessions (permanent):**

Add `superpowers` to the `toolsets` list in `~/.hermes/config.yaml`:
```yaml
toolsets:
- hermes-cli
- superpowers
```

**Specific platform agent (e.g., Discord, Telegram):**

Add `superpowers` to that platform's entry in `platform_toolsets` in `~/.hermes/config.yaml`:
```yaml
platform_toolsets:
  discord:
  - hermes-discord
  - superpowers
```

**Verify activation:**
```bash
hermes chat --toolsets superpowers -q "Which superpowers skills are available?"
```
The agent should list all 14 skills from the `skills/superpowers/` directory.

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
