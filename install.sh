#!/usr/bin/env bash
set -euo pipefail

REPO="ohprettyhak/review-pr-skill"
BRANCH="main"
RAW_BASE="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
SKILL_FILE="SKILL.md"

# ── Tool detection ──────────────────────────────────────────────────────────
# All tools follow the Agent Skills standard (agentskills.io):
#   <config>/skills/<skill-name>/SKILL.md

TOOLS="claude codex amp gemini opencode"
DETECTED=""

tool_marker() {
  case "$1" in
    claude)   echo "${HOME}/.claude" ;;
    codex)    echo "${HOME}/.agents" ;;
    amp)      echo "${HOME}/.config/agents" ;;
    gemini)   echo "${HOME}/.gemini" ;;
    opencode) echo "${HOME}/.config/opencode" ;;
  esac
}

tool_install() {
  local tool="$1"
  case "$tool" in
    claude)
      local dir="${HOME}/.claude/skills/review-pr"
      mkdir -p "$dir"
      curl -fsSL "${RAW_BASE}/${SKILL_FILE}" -o "${dir}/${SKILL_FILE}"
      echo "  [+] Claude Code: ${dir}/${SKILL_FILE}"
      ;;
    codex)
      local dir="${HOME}/.agents/skills/review-pr"
      mkdir -p "$dir"
      curl -fsSL "${RAW_BASE}/${SKILL_FILE}" -o "${dir}/${SKILL_FILE}"
      echo "  [+] Codex CLI:   ${dir}/${SKILL_FILE}"
      ;;
    amp)
      local dir="${HOME}/.config/agents/skills/review-pr"
      mkdir -p "$dir"
      curl -fsSL "${RAW_BASE}/${SKILL_FILE}" -o "${dir}/${SKILL_FILE}"
      echo "  [+] Amp Code:    ${dir}/${SKILL_FILE}"
      ;;
    gemini)
      local dir="${HOME}/.gemini/skills/review-pr"
      mkdir -p "$dir"
      curl -fsSL "${RAW_BASE}/${SKILL_FILE}" -o "${dir}/${SKILL_FILE}"
      echo "  [+] Gemini CLI:  ${dir}/${SKILL_FILE}"
      ;;
    opencode)
      local dir="${HOME}/.config/opencode/skills/review-pr"
      mkdir -p "$dir"
      curl -fsSL "${RAW_BASE}/${SKILL_FILE}" -o "${dir}/${SKILL_FILE}"
      echo "  [+] OpenCode:    ${dir}/${SKILL_FILE}"
      ;;
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
  echo "  - Codex CLI     (~/.agents)"
  echo "  - Amp Code      (~/.config/agents)"
  echo "  - Gemini CLI    (~/.gemini)"
  echo "  - OpenCode      (~/.config/opencode)"
  exit 1
fi

# ── Install ─────────────────────────────────────────────────────────────────

echo "review-pr-skill installer"
echo "========================="
echo ""
echo "Detected: ${DETECTED}"
echo ""

for tool in $DETECTED; do
  tool_install "$tool"
done

echo ""
echo "Usage:"
echo "  /review-pr          Review current branch's PR"
echo "  /review-pr 52       Review PR #52"
echo ""
echo "Done."
