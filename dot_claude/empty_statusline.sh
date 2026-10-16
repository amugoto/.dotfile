#!/usr/bin/env bash

# ─────────────────────────────────────────────
# Configuration
# ─────────────────────────────────────────────

BAR_WIDTH=10

# Nerd Font Icons
ICON_MODEL=""
ICON_GIT=""
ICON_JJ=""
ICON_PATH=""

# ─────────────────────────────────────────────
# ANSI Colors (24-bit True Color)
# ─────────────────────────────────────────────

RESET=$'\033[0m'

# General
C_TEXT=$'\033[38;2;209;213;219m'
C_DIM=$'\033[38;2;107;114;128m'

# Model
C_MODEL=$'\033[38;2;217;119;87m'
C_EFFORT=$'\033[38;2;147;197;253m'

# Git
C_GIT=$'\033[38;2;240;80;50m'
C_BRANCH=$'\033[38;2;209;213;219m'

# Jujutsu
C_JJ=$'\033[38;2;167;139;250m'
C_CHANGE=$'\033[38;2;196;181;253m'
C_BOOKMARK=$'\033[38;2;251;191;36m'

# Path
C_PATH=$'\033[38;2;148;163;184m'

# Usage
C_GREEN=$'\033[38;2;74;222;128m'
C_YELLOW=$'\033[38;2;250;204;21m'
C_RED=$'\033[38;2;248;113;113m'
C_EMPTY=$'\033[38;2;75;85;99m'

# Separator
SEP="${C_DIM} │ ${RESET}"

# Generate usage progress bar
# usage_bar <label> <percentage>
usage_bar() {
  local label="$1"
  local pct="$2"

  if [[ ! "$pct" =~ ^[0-9]+$ ]]; then
    printf '%s' "${C_DIM}${label} --${RESET}"
    return
  fi

  # Clamp percentage
  ((pct > 100)) && pct=100

  local filled=$(((pct * BAR_WIDTH + 50) / 100))
  local empty=$((BAR_WIDTH - filled))

  local color="$C_GREEN"

  if ((pct >= 80)); then
    color="$C_RED"
  elif ((pct >= 50)); then
    color="$C_YELLOW"
  fi

  local used_bar=""
  local remaining_bar=""
  local i

  for ((i = 0; i < filled; i++)); do
    used_bar+="█"
  done

  for ((i = 0; i < empty; i++)); do
    remaining_bar+="░"
  done

  printf '%s' \
    "${C_TEXT}${label}${RESET} " \
    "${color}${used_bar}" \
    "${C_EMPTY}${remaining_bar}${RESET} " \
    "${C_TEXT}${pct}%${RESET}"
}

# ─────────────────────────────────────────────
# Claude Code Input
# ─────────────────────────────────────────────

command -v jq >/dev/null 2>&1 || exit 0

input=$(cat)

# Parse JSON once
parsed=$(printf '%s' "$input" | jq -r '
    def percentage:
        if type == "number" then
            ((. + 0.5) | floor | tostring)
        else
            ""
        end;

    [
        (.model.display_name // ""),
        (.effort.level // ""),
        (.workspace.current_dir // .cwd // ""),
        (.rate_limits.five_hour.used_percentage | percentage),
        (.rate_limits.seven_day.used_percentage | percentage)
    ] | join("\u001f")
' 2>/dev/null) || exit 0

IFS=$'\x1f' read -r \
  model effort cwd rate5 rate7 <<<"$parsed"

# ─────────────────────────────────────────────
# Model & Effort
# ─────────────────────────────────────────────

model_part=""

if [[ -n "$model" ]]; then
  model_part="${C_MODEL}${ICON_MODEL}${RESET}"
  model_part+=" ${C_TEXT}${model}${RESET}"

  if [[ -n "$effort" ]]; then
    model_part+=" ${C_EFFORT}(${effort})${RESET}"
  fi
fi

# ─────────────────────────────────────────────
# Git
# ─────────────────────────────────────────────

git_part=""

if [[ -n "$cwd" && -d "$cwd" ]] &&
  command -v git >/dev/null 2>&1; then

  if [[ $(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" rev-parse \
    --is-inside-work-tree 2>/dev/null) == "true" ]]; then

    branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" \
      symbolic-ref --quiet --short HEAD 2>/dev/null)

    [[ -z "$branch" ]] && branch="detached"

    git_part="${C_GIT}${ICON_GIT}${RESET}"
    git_part+=" ${C_BRANCH}${branch}${RESET}"
  fi
fi

# ─────────────────────────────────────────────
# Jujutsu
# ─────────────────────────────────────────────

jj_part=""

if [[ -n "$cwd" && -d "$cwd" ]] &&
  command -v jj >/dev/null 2>&1; then

  jj_info=$(
    cd "$cwd" || exit 1

    if jj --ignore-working-copy root >/dev/null 2>&1; then
      jj --ignore-working-copy --color never log \
        --no-graph \
        -r @ \
        -T 'change_id.short(8) ++ "\t" ++ local_bookmarks.map(|b| b.name()).join(", ") ++ "\n"' \
        2>/dev/null
    fi
  )

  if [[ -n "$jj_info" ]]; then
    IFS=$'\t' read -r change_id bookmarks <<<"$jj_info"

    if [[ -n "$change_id" ]]; then
      jj_part="${C_JJ}${ICON_JJ}${RESET}"
      jj_part+=" ${C_CHANGE}${change_id}${RESET}"

      if [[ -n "$bookmarks" ]]; then
        jj_part+=" ${C_BOOKMARK}(${bookmarks})${RESET}"
      fi
    fi
  fi
fi

# ─────────────────────────────────────────────
# Current Path
# ─────────────────────────────────────────────

path_part=""

if [[ -n "$cwd" ]]; then
  display_path="$cwd"

  # Replace home directory with ~
  if [[ "$cwd" == "$HOME" ]]; then
    display_path="~"
  elif [[ "$cwd" == "$HOME/"* ]]; then
    display_path="~${cwd#$HOME}"
  fi

  path_part="${C_PATH}${ICON_PATH}  ${display_path}${RESET}"
fi

# ─────────────────────────────────────────────
# Rate Limits
# ─────────────────────────────────────────────

rate5_part=$(usage_bar "5h" "$rate5")
rate7_part=$(usage_bar "7d" "$rate7")

# ─────────────────────────────────────────────
# Final Output
# ─────────────────────────────────────────────

output=""

# Join non-empty parts
add() {
  [[ -z "$1" ]] && return

  if [[ -z "$output" ]]; then
    output="$1"
  else
    output="${output}${SEP}$1"
  fi
}

add "$model_part"
add "$git_part"
add "$jj_part"
add "$path_part"
add "$rate5_part"
add "$rate7_part"

printf '%s\n' "$output"
