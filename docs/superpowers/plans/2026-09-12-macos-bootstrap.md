# macOS 개발 환경 부트스트랩 구현 계획

> **실행 방식:** 승인된 설계에 따라 현재 세션에서 순서대로 구현한다. 기존 사용자 변경인 `dot_config/ghostty/config`, `dot_config/herdr/config.toml`, `dot_config/zsh/completion.zsh`는 보존하고 이 계획의 대상 파일만 수정한다.

**목표:** macOS만 설치된 Apple Silicon Mac에서 Bash 진입점 하나로 Command Line Tools, Homebrew, chezmoi, 패키지, dotfiles, macOS defaults를 순서대로 준비하고, 실패 후 또는 완료 후 재실행해도 기존 상태를 파괴하지 않는다.

**구성:** `bootstrap.sh`는 최초 도구 준비와 chezmoi 초기화만 담당한다. Homebrew 목표 상태는 source-only `Brewfile`, 패키지와 macOS 설정의 변경 감지는 `.chezmoiscripts`의 `run_onchange` wrapper, dotfiles 배치는 기존 chezmoi source state가 담당한다.

**기술:** macOS `/bin/bash`, Xcode Command Line Tools, Homebrew Bundle, chezmoi templates/scripts, Git

---

## 1. Homebrew 목표 상태 확정

**대상:**
- 추가: `/Users/ingon/.dotfiles/Brewfile`
- 수정: `/Users/ingon/.dotfiles/.chezmoiignore`

1. 현재 Mac의 `brew leaves`, `brew list --cask`, `brew tap` 결과를 직접 설치 목록의 기준선으로 사용하고, dotfiles 외부 실행 파일 감사를 통해 전이 의존성으로만 설치된 필수 도구를 보강한다.
2. 다음 두 사용자 tap만 선언한다.
   - `can1357/tap`
   - `laishulu/homebrew`
3. 다음 formula를 선언한다.

```text
awscli
bat
can1357/tap/omp
carapace
cask
chezmoi
colima
convmv
d2
docker
docker-buildx
docker-compose
fd
fzf
git
git-delta
gitui
graphviz
herdr
htop
jj
jjui
k9s
kotlin
kubecolor
kubectx
kubernetes-cli
laishulu/homebrew/macism
lsd
mise
neovim
nushell
oha
pandoc
pnpm
podman-compose
poppler
python
qemu
repomix
ripgrep
serpl
sheets
shellcheck
skaffold
starship
tmux
translate-shell
viu
yarn
yazi
zplug
```

4. 다음 cask를 선언한다.

```text
appcleaner
aws-vpn-client
chatgpt
chrome-remote-desktop-host
codex
dbeaver-community
font-fira-code
font-jetbrains-mono-nerd-font
font-nanum-gothic
ghostty
google-chrome
intellij-idea
kiro-cli
obsidian
openusage
postman
slack
spotify
utm
visual-studio-code
```

5. dotfiles가 직접 호출하지만 현재 다른 formula의 의존성으로만 설치된 `jj`, `python`, `ripgrep`, `tmux`와 Ghostty가 참조하지만 현재 Homebrew로 관리되지 않는 `font-nanum-gothic`을 명시한다.
6. `.chezmoiexternal.toml`이 TPM을 관리하므로 formula `tpm`은 제외한다. zplug가 같은 플러그인을 관리하므로 `powerlevel10k`, `zsh-autosuggestions`, `zsh-completions`, `zsh-fast-syntax-highlighting` formula도 중복 선언하지 않는다.
7. 폐기 예정 Homebrew DSL 경고를 내는 `hamidnazari/jetbrains-versions` tap과 `intellij-idea@2022.2.5` cask는 새 Mac 재현성에 부적합하므로 현재 `intellij-idea` cask로 교체한다.
8. Mac App Store 항목, VS Code 확장, cleanup/zap 지시, 전체 upgrade 지시는 추가하지 않는다.
9. `.chezmoiignore`에 `bootstrap.sh`와 `Brewfile`을 추가한다. 기존 `docs/superpowers/**` 제외 규칙은 유지한다.

**확인:** `brew bundle list --file Brewfile`이 의도한 tap/formula/cask만 출력하고, `chezmoi target-path Brewfile`과 `chezmoi target-path bootstrap.sh`가 배포 대상으로 나타나지 않는다.

## 2. Homebrew 변경 감지 스크립트 추가

**대상:**
- 추가: `/Users/ingon/.dotfiles/.chezmoiscripts/run_onchange_before_10-install-packages.sh.tmpl`

1. `/bin/bash` shebang과 `set -euo pipefail`을 사용한다.
2. 템플릿 주석에 `{{ include "Brewfile" | sha256sum }}` 결과를 포함해 Brewfile 내용 변경이 스크립트 변경으로 이어지게 한다.
3. `/opt/homebrew/bin/brew`가 없으면 원인을 명시하고 종료한다. Homebrew 설치는 이 wrapper가 아니라 `bootstrap.sh`의 책임으로 유지한다.
4. `brew shellenv`를 현재 프로세스에 반영한다.
5. `{{ joinPath .chezmoi.sourceDir "Brewfile" | quote }}`로 렌더링한 절대 경로를 `brew bundle --file`에 전달한다.
6. `--no-upgrade`를 사용해 누락된 선언만 설치하고 cleanup/zap은 호출하지 않는다.

**확인:** `chezmoi execute-template`로 렌더링했을 때 체크섬과 `/Users/ingon/.dotfiles/Brewfile` 경로가 들어가며, 렌더링 결과를 `/bin/bash -n`과 ShellCheck가 통과한다.

## 3. `.macos`를 멱등 실행 파일로 보강

**대상:**
- 수정: `/Users/ingon/.dotfiles/.macos`
- 추가: `/Users/ingon/.dotfiles/.chezmoiscripts/run_onchange_after_20-macos-defaults.sh.tmpl`

1. `.macos` 맨 앞에 `/bin/bash` shebang과 `set -euo pipefail`을 추가한다.
2. 기존 Keyboard, KeyBindings, 배터리, 시계, Finder, Mission Control, Dock 설정 값은 유지한다.
3. `DefaultKeyBinding.dict` 생성은 셸별 `echo -e` 동작에 의존하지 않도록 `printf` 또는 인용된 heredoc으로 바꾼다.
4. Dock, Finder, SystemUIServer, ControlCenter 재시작은 프로세스가 없는 경우만 허용하고 다른 설정 실패는 숨기지 않는다.
5. after wrapper에 `.macos` 내용 체크섬을 템플릿 주석으로 포함한다.
6. after wrapper는 `/bin/bash "$HOME/.macos"`만 실행한다. chezmoi application order상 갱신된 `.macos`가 홈에 배치된 뒤 실행된다.

**확인:** 두 파일의 렌더링 결과가 `/bin/bash -n`과 ShellCheck를 통과하고, `.macos`를 두 번 실행했을 때 같은 defaults 값이 유지된다.

## 4. 최초 진입점 `bootstrap.sh` 구현

**대상:**
- 추가: `/Users/ingon/.dotfiles/bootstrap.sh`

1. `/bin/bash` shebang과 `set -euo pipefail`을 사용하고, 현재 단계가 실패 메시지에 나타나도록 작은 `log`/`die` 함수와 `ERR` trap만 둔다.
2. 상수는 다음 값으로 고정한다.
   - source directory: `$HOME/.dotfiles`
   - repository: `https://github.com/amugoto/.dotfile.git`
   - branch: `config-nushell`
   - Homebrew prefix: `/opt/homebrew`
3. `uname -s`가 `Darwin`, `uname -m`이 `arm64`가 아니면 파일을 변경하기 전에 종료한다.
4. `xcode-select -p`가 실패하면 `xcode-select --install`로 공식 설치 UI를 열고, 사용자가 설치를 마친 뒤 Enter를 누르게 한다. 다시 `xcode-select -p`를 검사해 취소 또는 실패를 명확히 보고한다.
5. `command -v brew`가 실패하면 Homebrew 공식 설치 스크립트를 실행한다. 설치 후 `/opt/homebrew/bin/brew` 존재를 확인하고 `brew shellenv`를 반영한다.
6. `command -v chezmoi`가 실패하면 `brew install chezmoi`를 실행한다.
7. `$HOME/.dotfiles`가 없으면 다음 의미의 chezmoi 명령으로 지정 브랜치를 clone하고 적용한다.
   - `chezmoi init --source "$HOME/.dotfiles" --branch config-nushell --apply https://github.com/amugoto/.dotfile.git`
8. `$HOME/.dotfiles`가 있으면 Git 저장소인지 확인하고, `origin`이 같은 GitHub 저장소의 HTTPS 또는 SSH URL인지 확인하며, 현재 브랜치가 `config-nushell`인지 확인한다. 다른 디렉터리·원격·브랜치는 자동 이동·삭제·checkout하지 않고 종료한다.
9. 올바른 기존 저장소에서는 작업 트리 변경을 보존하고, 지정 source directory로 `chezmoi init --apply`만 실행한다.
10. 완료 메시지에는 현재 셸을 `source`하지 않고 새 터미널 세션을 시작하라고 안내한다.
11. 파일 머리말에 다음 기본 실행 흐름을 주석으로 남긴다.
   - raw GitHub URL에서 `/tmp/dotfiles-bootstrap.sh`로 다운로드
   - 내려받은 파일을 `/bin/bash`로 실행

**확인:** `/bin/bash -n`과 ShellCheck를 통과하고, 현재 Mac에서는 기존 Command Line Tools, Homebrew, chezmoi 및 올바른 저장소를 감지해 재설치하지 않는다.

## 5. chezmoi 렌더링과 배포 순서 검증

**대상:** `/Users/ingon/.dotfiles`

1. `chezmoi --source /Users/ingon/.dotfiles execute-template`로 두 wrapper를 렌더링하고 임시 렌더링 파일을 문법 검사한다.
2. `chezmoi --source /Users/ingon/.dotfiles apply --dry-run --verbose`에서 다음 순서를 확인한다.
   - before Homebrew wrapper
   - dotfiles 및 `.macos` 배치
   - after macOS defaults wrapper
3. `chezmoi --source /Users/ingon/.dotfiles target-path`로 `bootstrap.sh`와 `Brewfile`이 제외되고 `.macos`는 `$HOME/.macos`에 대응하는지 확인한다.
4. `brew bundle check --file /Users/ingon/.dotfiles/Brewfile`을 실행한다. `intellij-idea@2022.2.5`에서 `intellij-idea`로 전환한 차이만 있으면 실제 cask 교체를 부트스트랩 검증 전에 수행한다.
5. 임시 렌더링 파일은 제거한다.

**확인:** 템플릿 오류가 없고 실행 순서가 설계와 일치하며, source-only 파일이 홈에 배치되지 않는다.

## 6. 실제 부트스트랩 재실행 검증

**대상:** `/Users/ingon/.dotfiles/bootstrap.sh`

1. 구현 범위 밖의 사용자 변경 세 파일을 기록하고 건드리지 않는다.
2. `/bin/bash /Users/ingon/.dotfiles/bootstrap.sh`를 실제 실행한다.
3. 적용 후 `chezmoi --source /Users/ingon/.dotfiles diff`가 비어 있는지 확인한다.
4. 같은 명령을 즉시 한 번 더 실행한다.
5. 두 번째 실행에서 Command Line Tools, Homebrew, chezmoi를 재설치하지 않고, Homebrew cleanup/zap과 Git checkout/reset을 수행하지 않으며, 변경되지 않은 `run_onchange` wrapper가 다시 실행되지 않는지 출력으로 확인한다.
6. `brew bundle check --file /Users/ingon/.dotfiles/Brewfile`을 다시 실행한다.
7. `git diff --check`와 대상 파일의 최종 diff를 확인한다. 기존 사용자 변경은 그대로 남아 있어야 한다.

**완료 조건:** 현재 Mac에서 실제 부트스트랩을 연속 두 번 실행해 두 번째 실행이 안전한 no-op에 가깝고, Homebrew 선언·chezmoi 배포·macOS 설정이 목표 상태이며, 기존 사용자 변경을 덮어쓰거나 저장소 상태를 강제로 변경하지 않는다.
