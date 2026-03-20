#!/usr/bin/env bash
set -euo pipefail

REPO="ohprettyhak/review-pr-skills"
BRANCH="main"
RAW_BASE="https://raw.githubusercontent.com/${REPO}/${BRANCH}"

# ── Tool detection ──────────────────────────────────────────────────────────

TOOLS="claude codex amp gemini opencode"
DETECTED=""

tool_marker() {
  case "$1" in
    claude)   echo "${HOME}/.claude" ;;
    codex)    echo "${HOME}/.codex" ;;
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
      curl -fsSL "${RAW_BASE}/SKILL.md" -o "${dir}/SKILL.md"
      echo "  [+] Claude Code: ${dir}/SKILL.md"
      ;;
    codex)
      local dir="${HOME}/.codex/prompts"
      mkdir -p "$dir"
      curl -fsSL "${RAW_BASE}/SKILL.md" -o "${dir}/review-pr.md"
      echo "  [+] Codex CLI:   ${dir}/review-pr.md"
      ;;
    amp)
      local dir="${HOME}/.config/agents/skills/review-pr"
      mkdir -p "$dir"
      curl -fsSL "${RAW_BASE}/SKILL.md" -o "${dir}/SKILL.md"
      echo "  [+] Amp Code:    ${dir}/SKILL.md"
      ;;
    gemini)
      local dir="${HOME}/.gemini/commands"
      mkdir -p "$dir"
      curl -fsSL "${RAW_BASE}/review-pr.toml" -o "${dir}/review-pr.toml"
      echo "  [+] Gemini CLI:  ${dir}/review-pr.toml"
      ;;
    opencode)
      local dir="${HOME}/.config/opencode/commands"
      mkdir -p "$dir"
      curl -fsSL "${RAW_BASE}/SKILL.md" -o "${dir}/review-pr.md"
      echo "  [+] OpenCode:    ${dir}/review-pr.md"
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
  echo "  - Codex CLI     (~/.codex)"
  echo "  - Amp Code      (~/.config/agents)"
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
  tool_install "$tool"
done

echo ""
echo "Usage:"
echo "  /review-pr          Review current branch's PR"
echo "  /review-pr 52       Review PR #52"
echo ""
echo "Done."
