# review-pr-skills

Automated PR review response skill for AI coding assistants — evaluate each review comment, apply or reject with reasoning, react with usefulness feedback, and resolve threads.

## Supported Tools

| Tool | Install Path | Format |
|------|-------------|--------|
| Claude Code | `~/.claude/skills/review-pr/SKILL.md` | Markdown |
| Codex CLI | `~/.codex/prompts/review-pr.md` | Markdown |
| Amp Code | `~/.config/agents/skills/review-pr/SKILL.md` | Markdown |
| Gemini CLI | `~/.gemini/commands/review-pr.toml` | TOML |
| OpenCode | `~/.config/opencode/commands/review-pr.md` | Markdown |

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/ohprettyhak/review-pr-skills/main/install.sh | bash
```

The installer auto-detects which tools are installed and adds the skill to each one.

## Usage

```
/review-pr          # Review current branch's PR
/review-pr 52       # Review PR #52
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
rm -rf ~/.claude/skills/review-pr
rm -f ~/.codex/prompts/review-pr.md
rm -rf ~/.config/agents/skills/review-pr
rm -f ~/.gemini/commands/review-pr.toml
rm -f ~/.config/opencode/commands/review-pr.md
```

## License

MIT
