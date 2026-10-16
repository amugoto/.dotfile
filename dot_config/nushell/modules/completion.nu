const completion_command_map = {
  kubecolor: "kubectl",
}

let carapace_completer = {|place: record|
  CARAPACE_LENIENT=1 carapace $place.command.0 nushell ...$place.command | from json
}

let external_completer = {|place: record|
  let expanded_alias = scope aliases
    | where name == $place.command.0
    | get -o 0?.expansion
    | default []
    | split row " "

  let base_command = if ($expanded_alias | is-empty) {
      $place.command.0
    } else {
      $expanded_alias | first
    }

  let completion_command = $completion_command_map | get -o $base_command | default $base_command
  let normalized_place = $place | upsert command ($place.command | skip 1 | prepend $completion_command)

  match $completion_command {
    nu => null
    _ => $carapace_completer
  } | do $in $normalized_place
}

let updated_external = {
  enable: true
  max_results: 100
  completer: $external_completer
}
$env.config = ($env.config | upsert completions.external $updated_external)
