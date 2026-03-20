#!/bin/bash
set -euo pipefail

REPO="haklee/claude-skill-review-pr"
BRANCH="main"
SKILL_FILE="review-pr.md"
SKILL_DIR="${HOME}/.claude/commands"

echo "Installing /review-pr skill for Claude Code..."

mkdir -p "$SKILL_DIR"

curl -fsSL "https://raw.githubusercontent.com/${REPO}/${BRANCH}/${SKILL_FILE}" \
  -o "${SKILL_DIR}/${SKILL_FILE}"

echo ""
echo "Installed: ${SKILL_DIR}/${SKILL_FILE}"
echo ""
echo "Usage:"
echo "  /review-pr          Review current branch's PR"
echo "  /review-pr 52       Review PR #52"
echo ""
echo "Done."
