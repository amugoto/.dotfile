# 검색어에 해당하는 파일 찾기
function fif() {
  if [ ! "$#" -gt 0 ]; then echo "검색어를 입력해주세요."; return 1; fi
  rg --files-with-matches --no-messages --hidden -g '!{.git,.vscode/extensions,node_modules}' $2 "$1" | fzf\
  --border\
  --height 80%\
  --extended\
  --ansi\
  --reverse\
  --cycle\
  --header 'Find in File'\
  --bind 'f1:execute(less -f {}),ctrl-y:execute-silent(echo {} | pbcopy)+abort'\
  --bind 'alt-p:preview-up,alt-n:preview-down'\
  --bind 'ctrl-u:half-page-up,ctrl-d:half-page-down'\
  --bind '?:toggle-preview,alt-w:toggle-preview-wrap'\
  --bind 'alt-v:execute(nvim {} >/dev/tty </dev/tty)'\
  --preview "bat --theme='OneHalfDark' --style=numbers --color=always {} | rg --colors 'match:fg:white' --colors 'match:bg:red' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

# 디렉토리 찾기
function fdir() {
  local dir
  dir=$(fd --type d --hidden --follow --exclude .git 2>/dev/null | fzf\
  --header 'Search In Directory'\
  --border\
  --height 80%\
  --extended\
  --ansi\
  --reverse\
  --cycle\
  --header 'Search Directory'\
  --bind 'alt-p:preview-up,alt-n:preview-down'\
  --bind 'ctrl-u:half-page-up,ctrl-d:half-page-down'\
  --bind "alt-s:execute(lsd {})+abort"\
  --bind '?:toggle-preview,alt-w:toggle-preview-wrap'\
  --bind 'alt-v:execute($EDITOR {$FZF_PATH_LOC} >/dev/tty </dev/tty)'\
  --preview 'lsd --color=always --tree --depth=2  {} | head -200 2>/dev/null'\
  --preview-window=right:50%) && cd "$dir"
}

# nvm .nvmrc 파일 체크해서 node version 설정
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
# chpwd: 디렉토리가 변경될때 마다 실행의 의미
add-zsh-hook chpwd load-nvmrc
load-nvmrc
