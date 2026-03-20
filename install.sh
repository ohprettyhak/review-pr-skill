#!/usr/bin/env bash
set -euo pipefail

REPO="ohprettyhak/review-pr-skills"
BRANCH="main"
RAW_BASE="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
SKILL_FILE="review-pr.md"

# ── Tool detection ──────────────────────────────────────────────────────────

TOOLS="claude codex amp gemini opencode"
DETECTED=""

tool_marker() {
  case "$1" in
    claude)   echo "${HOME}/.claude" ;;
    codex)    echo "${HOME}/.codex" ;;
    amp)      echo "${HOME}/.amp" ;;
    gemini)   echo "${HOME}/.gemini" ;;
    opencode) echo "${HOME}/.config/opencode" ;;
  esac
}

tool_dir() {
  case "$1" in
    claude)   echo "${HOME}/.claude/commands" ;;
    codex)    echo "${HOME}/.codex/commands" ;;
    amp)      echo "${HOME}/.amp/commands" ;;
    gemini)   echo "${HOME}/.gemini/commands" ;;
    opencode) echo "${HOME}/.config/opencode/commands" ;;
  esac
}

for tool in $TOOLS; do
  marker=$(tool_marker "$tool")
  if [ -d "$marker" ]; then
    DETECTED="${DETECTED} ${tool}"
  fi
done

DETECTED=$(echo "$DETECTED" | xargs)

if [ -z "$DETECTED" ]; then
  echo "No supported AI coding tools detected."
  echo ""
  echo "Supported tools (install any, then re-run):"
  echo "  - Claude Code   (~/.claude)"
  echo "  - Codex CLI     (~/.codex)"
  echo "  - Amp Code      (~/.amp)"
  echo "  - Gemini CLI    (~/.gemini)"
  echo "  - OpenCode      (~/.config/opencode)"
  exit 1
fi

# ── Install ─────────────────────────────────────────────────────────────────

echo "review-pr-skills installer"
echo "========================="
echo ""
echo "Detected: ${DETECTED}"
echo ""

for tool in $DETECTED; do
  dir=$(tool_dir "$tool")
  mkdir -p "$dir"
  curl -fsSL "${RAW_BASE}/${SKILL_FILE}" -o "${dir}/${SKILL_FILE}"
  echo "  [+] ${tool}: ${dir}/${SKILL_FILE}"
done

echo ""
echo "Usage:"
echo "  /review-pr          Review current branch's PR"
echo "  /review-pr 52       Review PR #52"
echo ""
echo "Done."
