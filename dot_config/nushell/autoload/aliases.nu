alias l = ls
alias ll = ls -al
def lss [
  ...pattern: glob,
] {
  let pattern = if ($pattern | is-empty) { [ '.' ] } else { $pattern }
  ls -al ...$pattern | select name type mode size user group created modified
}
alias cat = bat
alias vim = nvim
alias vi = nvim
alias vimdiff = nvim -d
alias k = kubecolor
alias kubectl = kubecolor
alias grep = rg
alias top = htop
alias image = viu
