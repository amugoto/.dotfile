# macOS 개발 환경 부트스트랩 설계

## 목표

macOS만 설치된 Apple Silicon Mac에서 한 가지 표준 개발 환경을 재현한다. 최초 진입점은 macOS에 기본 포함된 Bash로 작성하고, 패키지는 Homebrew Bundle, dotfiles와 후속 작업은 chezmoi가 관리한다. 설치가 중간에 실패해도 같은 명령을 다시 실행해 안전하게 이어갈 수 있어야 한다.

## 전제

- 대상 OS는 지원 중인 Apple Silicon macOS다.
- 저장소는 공개 HTTPS로 접근할 수 있다.
- 적용 대상은 `config-nushell` 브랜치다.
- 모든 Mac에 동일한 패키지와 설정을 적용한다.
- Command Line Tools, Homebrew, chezmoi, Node.js가 없는 상태에서 시작할 수 있어야 한다.
- Command Line Tools와 Homebrew 설치, chezmoi의 Git 이름·이메일 입력에는 사용자 상호작용을 허용한다.

## 범위

### 포함

- Xcode Command Line Tools 설치 상태 확인과 설치 시작
- Homebrew와 chezmoi 설치
- 저장소를 `~/.dotfiles`에 초기화하고 적용
- Homebrew formula와 cask 설치
- 현재 chezmoi dotfiles 배치와 외부 TPM 저장소 적용
- macOS defaults 적용
- 중단 후 재실행과 기존 설치 재사용

### 제외

- Intel Mac과 macOS 이외의 운영체제
- 여러 기기 또는 개인·업무 프로필 분기
- Mac App Store 앱 설치
- 앱 로그인, 라이선스 등록, SSH/GPG 키와 기타 비밀정보 복원
- 선언되지 않은 Homebrew 패키지 및 앱 삭제
- 기존 패키지 전체 자동 업그레이드

## 접근법

얇은 `bootstrap.sh`와 선언형 도구를 조합한다.

Node.js는 새 Mac에 존재하지 않으므로 최초 진입점으로 사용하지 않는다. 단일 대형 셸 스크립트도 dotfiles 배치, 패키지 상태, macOS 설정을 직접 관리하게 되어 기존 chezmoi와 책임이 중복된다. `bootstrap.sh`는 필수 도구 준비와 chezmoi 시작까지만 담당하고, 원하는 최종 상태는 `Brewfile`과 chezmoi source state에 둔다.

## 구성 요소

```text
bootstrap.sh
Brewfile
.chezmoiignore
.macos
.chezmoiscripts/
  run_onchange_before_10-install-packages.sh.tmpl
  run_onchange_after_20-macos-defaults.sh.tmpl
```

### `bootstrap.sh`

- macOS와 Apple Silicon 환경인지 검사하고 다른 환경에서는 변경 없이 종료한다.
- `xcode-select -p`로 Command Line Tools를 확인한다. 없으면 공식 설치 UI를 시작하고 설치 완료 후 계속한다.
- `command -v brew`로 Homebrew를 확인하고, 없으면 공식 설치 스크립트를 실행한다.
- Apple Silicon 기본 prefix의 `brew shellenv`를 현재 프로세스에 반영한다.
- chezmoi가 없으면 Homebrew로 설치한다.
- `~/.dotfiles`가 없으면 `https://github.com/amugoto/.dotfile.git`의 `config-nushell` 브랜치를 해당 경로에 초기화한다.
- `~/.dotfiles`가 같은 원격 저장소의 `config-nushell` 브랜치면 작업 트리 변경을 보존한 채 재사용한다. 일반 파일·디렉터리, 다른 원격 저장소, 다른 브랜치라면 자동 변경하지 않고 오류로 종료한다.
- 마지막으로 지정한 source directory를 사용해 chezmoi init/apply를 실행한다. 충돌 시 강제 덮어쓰지 않는다.

초기 사용법은 `https://raw.githubusercontent.com/amugoto/.dotfile/config-nushell/bootstrap.sh`를 임시 경로에 내려받은 뒤 `/bin/bash`로 실행하는 두 단계 명령으로 제공한다. 다운로드한 코드를 검토할 수 없게 만드는 `curl | sh`를 기본 사용법으로 삼지 않는다.

### `Brewfile`

현재 Mac의 `brew bundle dump` 결과를 출발점으로 삼되 그대로 커밋하지 않는다. 다음 기준으로 검토한 formula와 cask만 선언한다.

- 현재 사용하는 개발 도구와 GUI 앱
- Nushell, Neovim, Ghostty, Yazi 등 저장소 설정이 직접 참조하는 명령
- 사용자가 명시적으로 유지하려는 도구

전이 의존성, 시험 설치 후 방치한 도구, 대체된 앱, 오래된 `main` 브랜치의 잔재는 제외한다. 실제로 필요한 tap만 남긴다. `Brewfile`은 source-only 파일이며 홈 디렉터리에는 배치하지 않는다.

`brew bundle`은 누락된 선언을 설치하는 데만 사용한다. cleanup, zap, 전체 upgrade는 수행하지 않는다.

### Homebrew 변경 감지 스크립트

`.chezmoiscripts/run_onchange_before_10-install-packages.sh.tmpl`은 다음을 담당한다.

- 템플릿 주석에 `Brewfile` 내용 체크섬을 포함한다.
- `brew bundle --file`에는 `.chezmoi.sourceDir`로 렌더링한 `Brewfile`의 절대 경로를 전달한다.
- 첫 적용 또는 `Brewfile` 변경 때만 누락된 선언을 설치한다.
- dotfiles 배치 전에 필요한 실행 파일을 준비한다.

### `.macos`와 변경 감지 스크립트

`.macos`는 macOS 설정의 단일 원본이자 수동 실행 가능한 파일로 유지한다. chezmoi는 기존처럼 이를 `~/.macos`에 배치한다.

`.chezmoiscripts/run_onchange_after_20-macos-defaults.sh.tmpl`은 다음을 담당한다.

- 템플릿에 `.macos` 내용 체크섬을 포함한다.
- dotfiles 배치가 끝난 after 단계에서 `/bin/bash "$HOME/.macos"`를 실행한다.
- 첫 적용 또는 `.macos` 변경 때만 실행한다.

`.macos`의 `defaults write` 작업은 반복 실행해도 같은 결과를 내야 한다. Dock, Finder 등 재시작 대상 프로세스가 없다는 이유로 전체 적용이 실패하지 않도록 처리한다.

### 기존 chezmoi 구성

- `.chezmoi.toml.tmpl`의 Git 이름과 이메일 프롬프트를 유지한다.
- `.chezmoiexternal.toml`의 TPM 관리를 유지한다.
- `.chezmoiignore`에 `bootstrap.sh`와 `Brewfile`을 추가해 홈 디렉터리 배포 대상에서 제외한다.

## 실행 순서

1. 사용자가 `bootstrap.sh`를 다운로드하고 실행한다.
2. 스크립트가 플랫폼과 Command Line Tools를 확인한다.
3. Homebrew와 chezmoi를 필요한 경우에만 설치한다.
4. chezmoi가 `config-nushell` 브랜치를 `~/.dotfiles`에 초기화한다.
5. before 스크립트가 `Brewfile`의 누락된 패키지와 앱을 설치한다.
6. chezmoi가 dotfiles와 `.macos`를 홈 디렉터리에 적용하고 TPM을 준비한다.
7. after 스크립트가 macOS 설정을 적용한다.
8. 이후 변경은 `chezmoi update`로 가져오고 적용한다.

## 오류 처리와 안전성

- Bash 스크립트는 `set -euo pipefail`로 첫 실패에서 중단한다.
- 설치 상태는 명령의 종료 상태로 판단한다.
- 오류 출력은 숨기지 않으며 실패한 단계와 재실행 명령을 표시한다.
- 기존 파일, 저장소, chezmoi 충돌을 자동 삭제하거나 `--force`로 덮어쓰지 않는다.
- `sudo` 자격증명을 저장하거나 전달하지 않는다.
- 각 단계는 이미 완료된 상태를 정상 입력으로 취급한다.
- 자동 cleanup과 전체 upgrade를 하지 않아 부트스트랩 범위 밖의 사용자 설치물을 보존한다.

## 검증

1. `/bin/bash -n bootstrap.sh`로 셸 문법을 검사하고, 현재 환경에 ShellCheck가 있으면 정적 분석도 수행한다.
2. `chezmoi apply --dry-run --verbose`로 스크립트 순서와 대상 경로를 확인한다.
3. `brew bundle check --file Brewfile`로 현재 Mac이 선언된 목표 상태를 충족하는지 확인한다.
4. 현재 Mac에서 실제 `bootstrap.sh`를 실행해 기존 Homebrew, chezmoi, `~/.dotfiles`를 재사용하는지 확인한다.
5. 즉시 다시 실행해 재설치, 강제 덮어쓰기, cleanup, 예상하지 않은 chezmoi diff가 발생하지 않는지 확인한다.
6. Command Line Tools가 없는 신규 Mac 분기는 상태 검사와 공식 설치 명령을 정적으로 검토한다. 실제 신규 Mac 또는 macOS VM에서 최초 설치 시 최종 확인한다.

## 완료 기준

- macOS만 설치된 Apple Silicon Mac에서 하나의 부트스트랩 진입점으로 전체 개발 환경 설치가 시작된다.
- 중간 실패 후 같은 명령으로 안전하게 재개된다.
- 두 번째 실행은 이미 충족된 단계를 건너뛰고 사용자 파일이나 별도 설치물을 삭제하지 않는다.
- 패키지 목록과 macOS 설정이 변경되면 다음 `chezmoi update`에서 해당 단계만 다시 실행된다.
- `.macos`는 자동 적용과 수동 실행 양쪽에 사용할 수 있다.
