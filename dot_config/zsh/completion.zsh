
PATH_PREFIX="$(brew --prefix)/share/zsh/site-functions"

# k8s auto completion
source "$PATH_PREFIX/_kubectl"

# k9s auto completion
source "$PATH_PREFIX/_k9s"

# codex
source "$HOME/.codex/_codex"

# _chezmoi
source "$PATH_PREFIX/_chezmoi"

source "$PATH_PREFIX/_starship"

source "$PATH_PREFIX/_mise"

source "$PATH_PREFIX/_yazi"

source "$PATH_PREFIX/_herdr"

source "$PATH_PREFIX/_docker"

source "$PATH_PREFIX/_colima"
