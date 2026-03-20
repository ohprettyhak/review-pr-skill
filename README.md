# pr-review-skill

Automated PR review response skill for AI coding assistants — evaluate each review comment, apply or reject with reasoning, react with usefulness feedback, and resolve threads.

Follows the [Agent Skills](https://agentskills.io) open standard.

## Supported Tools

| Tool | Install Path |
|------|-------------|
| Claude Code | `~/.claude/skills/pr-review/SKILL.md` |
| Codex CLI | `~/.agents/skills/pr-review/SKILL.md` |
| Amp Code | `~/.config/agents/skills/pr-review/SKILL.md` |
| Gemini CLI | `~/.gemini/skills/pr-review/SKILL.md` |
| OpenCode | `~/.config/opencode/skills/pr-review/SKILL.md` |

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/ohprettyhak/pr-review-skill/main/install.sh | bash
```

The installer auto-detects which tools are installed and adds the skill to each one.

Or manually copy `SKILL.md` to your tool's skills directory.

## Usage

```
/pr-review          # Review current branch's PR
/pr-review 52       # Review PR #52
```

## What it does

For each unresolved review thread on the PR:

1. **Evaluate** — reads the comment and referenced code
2. **Decide** — Apply (correctness, security, contract) or Reject (style, infeasible, out of scope)
3. **Fix** — applies code changes, runs lint/typecheck
4. **Reply** — posts "Applied" or "Rejected" with reasoning
5. **React** — adds a thumbs up/down reaction for usefulness feedback
6. **Resolve** — marks the thread as resolved

Then commits all changes in one batch and prints a summary table.

## Reaction rules

| Decision | Reaction | When |
|----------|----------|------|
| Applied | thumbs up | Always |
| Rejected (valid concern) | thumbs up | Out of scope or infeasible, but the analysis was correct |
| Rejected (wrong analysis) | thumbs down | False positive, incorrect understanding of the code |

## Customization

The skill reads `AGENTS.md` if present in the repo root. Project-specific review policies in `AGENTS.md` override the defaults.

## Requirements

- [GitHub CLI](https://cli.github.com/) (`gh`) authenticated
- One or more supported AI coding tools installed

## Uninstall

```bash
rm -rf ~/.claude/skills/pr-review
rm -rf ~/.agents/skills/pr-review
rm -rf ~/.config/agents/skills/pr-review
rm -rf ~/.gemini/skills/pr-review
rm -rf ~/.config/opencode/skills/pr-review
```

## License

MIT
