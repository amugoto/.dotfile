export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

export ZPLUG_HOME=/opt/homebrew/opt/zplug

# set brew path
if [[ $(arch) == "arm64" ]]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:$PATH"
else
  export PATH="/usr/local/bin:/usr/local/sbin:/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
fi

# fzf
export fzf_default_command="fd --type f --color=always --follow --hidden --exclude .git"
export fzf_ctrl_t_command="$fzf_default_command"
export fzf_default_opts="--ansi"
