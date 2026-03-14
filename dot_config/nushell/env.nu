use std/util "path add"

# "/usr/local/bin"
# "/usr/local/sbin"

path add "/opt/homebrew/bin"
path add "/opt/homebrew/sbin"


let mise_version = mise -v | split row " "  | first
let mise_file = $nu.default-config-dir | path join $"autoload/mise-($mise_version).nu"

if not ($mise_file | path exists) {
  let autoload_dir = $mise_file | path dirname
  if not ($autoload_dir | path exists) {
    mkdir $autoload_dir
  }

  ^mise activate nu | save -f $mise_file
}
