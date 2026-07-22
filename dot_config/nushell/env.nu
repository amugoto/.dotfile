use std/util "path add"

# "/usr/local/bin"
# "/usr/local/sbin"

path add "/opt/homebrew/bin"
path add "/opt/homebrew/sbin"
path add "/usr/local/bin"


let mise_version = mise -v | split row " "  | first | str replace --all "." "-"
let mise_file = $nu.default-config-dir | path join $"autoload/mise-($mise_version).nu"

if not ($mise_file | path exists) {
  let autoload_dir = $mise_file | path dirname
  if not ($autoload_dir | path exists) {
    mkdir $autoload_dir
  }

  ^mise activate nu | save -f $mise_file

  for item in (ls -al ~/.config/nushell/autoload | where name like "mise" and type == "file" and name not-like $mise_file) {
    rm $item.name
  }
}
