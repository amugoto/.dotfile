#!/usr/bin/env zsh

BASE_PATH="$HOME/.dotfiles"

# 영문자 반복 입력 가능하도록 설정
defaults write -g ApplePressAndHoldEnabled -bool false

# 백틱 입력되도록 설정
mkdir -p "$HOME/Library/KeyBindings"
echo -e "{"\\n\\t'"₩" = ("insertText:", "`");'\\n"}" > "$HOME/Library/KeyBindings/DefaultkeyBinding.dict"

# link .zshrc
ln -s "$BASE_PATH/zsh/.zshrc" ~/.zshrc

# brew install
if ! which brew
then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else 
  echo "Brew is already installed."
fi

# brew package install
echo "Installing brew packages..."
brew bundle
echo "Completed brew packages!!!"

# set neovim
cp -R "$BASE_PATH/nvim" "$HOME/.config/nvim"

# vscode extensions install
# code --list-extensions > extensions.list 
cat "$BASE_PATH/.vscode/extensions.list" | xargs -L 1 code --install-extension

source ~/.zshrc
p10k configure


echo "축하합니다. 모든 세팅을 끝냈습니다.  쉘을 완전히 껐다가 새로 시작해주세요."
