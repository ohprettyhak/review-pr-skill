---
description: Respond to PR review comments — evaluate, apply/reject, reply, react, resolve
---

# PR Review Response

You are responding to review comments on a GitHub PR. Follow this workflow exactly.

## Input

- Argument `$ARGUMENTS` may contain a PR number. If empty, detect from current branch with `gh pr view --json number --jq .number`.
- Read the repository's `AGENTS.md` if it exists — it may contain project-specific review policies that override defaults below.

## Step 1: Collect unresolved review threads

```bash
# Get repo info
REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
PR_NUMBER=${PR_NUMBER:-$(gh pr view --json number --jq .number)}

# Get unresolved threads with comment details
gh api graphql -f query='
{
  repository(owner: "OWNER", name: "REPO") {
    pullRequest(number: PR_NUM) {
      reviewThreads(first: 50) {
        nodes {
          id
          isResolved
          comments(first: 1) {
            nodes {
              databaseId
              body
              path
              line
              originalLine
              diffHunk
            }
          }
        }
      }
    }
  }
}'
```

Filter to `isResolved == false` threads only. If none exist, report "No unresolved review threads" and stop.

## Step 2: Evaluate each comment

For each unresolved thread, read the referenced file and surrounding code. Then decide:

### Apply when:
- **Correctness**: the comment identifies a real bug, crash, or logic error
- **Security**: the comment identifies a vulnerability (path traversal, injection, crashes from untrusted input)
- **Contract violation**: the change breaks a documented interface, API, or behavioral contract

### Reject when:
- **Style preference**: the suggestion is cosmetic or subjective without clear benefit
- **Infeasible**: the fix is impossible given architectural constraints (e.g., Docker HEALTHCHECK can't read YAML)
- **Out of scope**: the issue exists but is unrelated to this PR's changes
- **Incorrect analysis**: the reviewer's understanding of the code is wrong

## Step 3: Apply fixes (if any)

For each "Apply" decision:
1. Make the code change
2. Run lint and typecheck to verify (adapt to the project's toolchain)
3. If lint/typecheck fails, fix before continuing

Do NOT commit yet — batch all fixes into one commit at the end.

## Step 4: Reply to each thread

For each comment, post a reply using:

```bash
gh api --method POST repos/{owner}/{repo}/pulls/{pr}/comments/{comment_id}/replies \
  -f body="<reply>"
```

### Reply format:

**If Applied:**
> **Applied.** <1-2 sentence explanation of what was changed and why.>

**If Rejected:**
> **Rejected.** <1-2 sentence explanation of why the feedback does not apply or conflicts with intentional design.>

## Step 5: React with usefulness feedback

After replying, react to the **original bot comment** (not your reply):

```bash
# Thumbs up — the comment was useful (Applied, or Rejected but valid insight)
gh api --method POST repos/{owner}/{repo}/pulls/comments/{comment_id}/reactions \
  -f content="+1"

# Thumbs down — the comment was not useful (incorrect analysis, false positive)
gh api --method POST repos/{owner}/{repo}/pulls/comments/{comment_id}/reactions \
  -f content="-1"
```

**Reaction rules:**
- Applied → always thumbs up
- Rejected but the concern was valid (just out of scope or infeasible) → thumbs up
- Rejected because the analysis was wrong or not useful → thumbs down

## Step 6: Resolve threads

After replying to a thread, resolve it:

```bash
gh api graphql -f query='mutation {
  resolveReviewThread(input: {threadId: "THREAD_ID"}) {
    thread { isResolved }
  }
}'
```

## Step 7: Commit and push

If any code changes were made:
1. Stage the changed files (specific files, not `git add -A`)
2. Commit with a descriptive message summarizing what was addressed
3. Push to the current branch

## Step 8: Summary

Print a summary table:

```
| # | File | Priority | Decision | Reaction |
|---|------|----------|----------|----------|
| 1 | path/to/file.ts | P1 | Applied | thumbs up |
| 2 | Dockerfile | P2 | Rejected | thumbs up |
```

Report total: `Applied: N, Rejected: M, Total: N+M`
