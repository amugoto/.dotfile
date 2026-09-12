#!/bin/bash

# Fresh macOS usage:
#   curl -fsSL \
#     https://raw.githubusercontent.com/amugoto/.dotfile/config-nushell/bootstrap.sh \
#     -o /tmp/dotfiles-bootstrap.sh
#   /bin/bash /tmp/dotfiles-bootstrap.sh

set -Eeuo pipefail

readonly SOURCE_DIR="$HOME/.dotfiles"
readonly REPOSITORY="https://github.com/amugoto/.dotfile.git"
readonly BRANCH="config-nushell"
readonly BREW_BIN="/opt/homebrew/bin/brew"

CURRENT_STEP="초기화"

log() {
  printf '\n==> %s\n' "$1"
}

die() {
  printf '오류: %s\n' "$1" >&2
  exit 1
}

on_error() {
  local status=$?
  printf '오류: %s 단계가 종료 코드 %d로 실패했습니다. 문제를 해결한 뒤 이 스크립트를 다시 실행하세요.\n' \
    "$CURRENT_STEP" "$status" >&2
  exit "$status"
}

is_expected_remote() {
  case "$1" in
    "$REPOSITORY"|"https://github.com/amugoto/.dotfile"|"git@github.com:amugoto/.dotfile.git"|"git@github.com:amugoto/.dotfile")
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

trap on_error ERR

CURRENT_STEP="플랫폼 확인"
[[ "$(uname -s)" == "Darwin" ]] || die "이 부트스트랩은 macOS만 지원합니다."
[[ "$(uname -m)" == "arm64" ]] || die "이 부트스트랩은 Apple Silicon Mac만 지원합니다."

CURRENT_STEP="Xcode Command Line Tools 확인"
if ! xcode-select -p >/dev/null 2>&1; then
  log "Xcode Command Line Tools 설치"
  xcode-select --install
  printf '설치 창에서 Command Line Tools 설치를 마친 뒤 Enter를 누르세요: '
  if ! IFS= read -r _; then
    die "대화형 입력을 읽을 수 없습니다. 설치 완료 후 다시 실행하세요."
  fi
  xcode-select -p >/dev/null 2>&1 || die "Command Line Tools 설치를 확인할 수 없습니다."
else
  log "Xcode Command Line Tools가 이미 설치되어 있습니다."
fi

CURRENT_STEP="Homebrew 확인"
if ! command -v brew >/dev/null 2>&1; then
  log "Homebrew 설치"
  command -v curl >/dev/null 2>&1 || die "Homebrew 설치에 필요한 curl이 없습니다."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  log "Homebrew가 이미 설치되어 있습니다."
fi

[[ -x "$BREW_BIN" ]] || die "예상 경로 $BREW_BIN 에서 Homebrew를 찾을 수 없습니다."
eval "$("$BREW_BIN" shellenv)"

CURRENT_STEP="chezmoi 확인"
if ! command -v chezmoi >/dev/null 2>&1; then
  log "chezmoi 설치"
  "$BREW_BIN" install chezmoi
else
  log "chezmoi가 이미 설치되어 있습니다."
fi

CHEZMOI_BIN="$(command -v chezmoi)"
readonly CHEZMOI_BIN

CURRENT_STEP="dotfiles 저장소 확인"
if [[ -e "$SOURCE_DIR" ]]; then
  [[ -d "$SOURCE_DIR/.git" ]] || die "$SOURCE_DIR 가 Git 저장소가 아닙니다. 자동으로 덮어쓰지 않습니다."

  if ! remote_url="$(git -C "$SOURCE_DIR" config --get remote.origin.url)"; then
    die "$SOURCE_DIR 저장소에 origin 원격이 없습니다."
  fi
  is_expected_remote "$remote_url" || die "$SOURCE_DIR 의 origin이 예상 저장소와 다릅니다: $remote_url"

  if ! current_branch="$(git -C "$SOURCE_DIR" symbolic-ref --quiet --short HEAD)"; then
    die "$SOURCE_DIR 저장소가 브랜치에 checkout되어 있지 않습니다."
  fi
  [[ "$current_branch" == "$BRANCH" ]] || die "$SOURCE_DIR 의 현재 브랜치가 $BRANCH 가 아닙니다: $current_branch"

  CURRENT_STEP="기존 dotfiles 적용"
  log "기존 dotfiles 저장소 적용"
  "$CHEZMOI_BIN" init --source "$SOURCE_DIR" --apply --error-on-conflict
else
  CURRENT_STEP="dotfiles 초기화 및 적용"
  log "dotfiles 저장소 초기화 및 적용"
  "$CHEZMOI_BIN" init \
    --source "$SOURCE_DIR" \
    --branch "$BRANCH" \
    --apply \
    --error-on-conflict \
    "$REPOSITORY"
fi

trap - ERR
printf '\n설정이 완료되었습니다. 새 터미널 세션을 시작하세요.\n'
