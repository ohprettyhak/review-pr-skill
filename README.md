# review-pr-skills

Automated PR review response skill for AI coding assistants — evaluate each review comment, apply or reject with reasoning, react with usefulness feedback, and resolve threads.

## Supported Tools

| Tool | Directory |
|------|-----------|
| Claude Code | `~/.claude/commands/` |
| Codex CLI | `~/.codex/commands/` |
| Amp Code | `~/.amp/commands/` |
| Gemini CLI | `~/.gemini/commands/` |
| OpenCode | `~/.config/opencode/commands/` |

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/ohprettyhak/review-pr-skills/main/install.sh | bash
```

The installer auto-detects which tools are installed and adds the skill to each one.

Or manually copy `review-pr.md` to your tool's commands directory.

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
5. **React** — adds a reaction to the bot comment for usefulness feedback
6. **Resolve** — marks the thread as resolved

Then commits all changes in one batch and prints a summary table.

## Reaction rules

| Decision | Reaction | When |
|----------|----------|------|
| Applied | 👍 | Always |
| Rejected (valid concern) | 👍 | Out of scope or infeasible, but the analysis was correct |
| Rejected (wrong analysis) | 👎 | False positive, incorrect understanding of the code |

## Customization

The skill reads `AGENTS.md` if present in the repo root. Project-specific review policies in `AGENTS.md` override the defaults.

## Requirements

- [GitHub CLI](https://cli.github.com/) (`gh`) authenticated
- One or more supported AI coding tools installed

## Uninstall

Remove `review-pr.md` from your tool's commands directory:

```bash
rm ~/.claude/commands/review-pr.md
rm ~/.codex/commands/review-pr.md
# etc.
```

## License

MIT
