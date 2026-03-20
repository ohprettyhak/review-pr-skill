# claude-skill-review-pr

A Claude Code skill that automates PR review responses — evaluate each review comment, apply or reject with reasoning, react with usefulness feedback, and resolve threads.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/ohprettyhak/claude-skill-review-pr/main/install.sh | bash
```

Or manually copy `review-pr.md` to `~/.claude/commands/`.

## Usage

```
/review-pr          # Review current branch's PR
/review-pr 52       # Review PR #52
```

## What it does

For each unresolved review thread:

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

- [Claude Code](https://claude.com/claude-code)
- [GitHub CLI](https://cli.github.com/) (`gh`) authenticated

## License

MIT
