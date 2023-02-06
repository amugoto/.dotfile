# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


DIR="$HOME/.zsh"

# Alias
source "$DIR/alias.zsh"

# Export
source "$DIR/export.zsh"

# ZPlug init
source "$ZPLUG_HOME/init.zsh"

# PlugIn
source "$DIR/plugin.zsh"

# Autoload
autoload -U add-zsh-hook

# Function
source "$DIR/function.zsh"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh