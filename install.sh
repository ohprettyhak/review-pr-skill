#!/usr/bin/env bash
set -euo pipefail

REPO="ohprettyhak/review-pr-skill"
BRANCH="main"
RAW_BASE="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
SKILL_FILE="SKILL.md"

# ── Color support ───────────────────────────────────────────────────────────

if [ -t 1 ]; then
  GREEN="\033[32m"
  RED="\033[31m"
  DIM="\033[2m"
  RESET="\033[0m"
else
  GREEN=""
  RED=""
  DIM=""
  RESET=""
fi

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

tool_label() {
  case "$1" in
    claude)   echo "Claude Code" ;;
    codex)    echo "Codex CLI" ;;
    amp)      echo "Amp Code" ;;
    gemini)   echo "Gemini CLI" ;;
    opencode) echo "OpenCode" ;;
  esac
}

tool_install() {
  local tool="$1"
  local label
  label=$(tool_label "$tool")

  local dir
  case "$tool" in
    claude)   dir="${HOME}/.claude/skills/review-pr" ;;
    codex)    dir="${HOME}/.agents/skills/review-pr" ;;
    amp)      dir="${HOME}/.config/agents/skills/review-pr" ;;
    gemini)   dir="${HOME}/.gemini/skills/review-pr" ;;
    opencode) dir="${HOME}/.config/opencode/skills/review-pr" ;;
  esac

  mkdir -p "$dir"
  if curl -fsSL "${RAW_BASE}/${SKILL_FILE}" -o "${dir}/${SKILL_FILE}" 2>/dev/null; then
    printf "  ${GREEN}✓${RESET} %s\n" "$label"
  else
    printf "  ${RED}✗${RESET} %s ${DIM}(download failed)${RESET}\n" "$label"
  fi
}

for tool in $TOOLS; do
  marker=$(tool_marker "$tool")
  if [ -d "$marker" ]; then
    DETECTED="${DETECTED} ${tool}"
  fi
done

DETECTED=$(echo "$DETECTED" | xargs)

if [ -z "$DETECTED" ]; then
  echo "No supported tools detected."
  echo ""
  echo "Install one of these first:"
  echo "  - Claude Code:  https://claude.ai/code"
  echo "  - Codex CLI:    https://codex.openai.com"
  echo "  - Amp Code:     https://ampcode.com"
  echo "  - Gemini CLI:   https://github.com/google-gemini/gemini-cli"
  echo "  - OpenCode:     https://opencode.ai"
  exit 1
fi

# ── Install ─────────────────────────────────────────────────────────────────

echo "Installing review-pr skill..."
echo ""

for tool in $DETECTED; do
  tool_install "$tool"
done

echo ""
echo "Done! The skill activates when you type /review-pr or when working on PR reviews."
