$env.config.show_banner = "short"
$env.config.buffer_editor = "code"
$env.config.rm = {
  always_trash: true
}
$env.config.datetime_format = {
  normal: "%F %H:%M:%S", # 일반 출력 형식
  table: "%y-%m-%d %H:%M:%S"           # 테이블 내에서의 형식

}

$env.config.table.trim = {
  methodology: truncating
  wrapping_try_keep_words: true
  truncating_suffix: "…"
}

source "./modules/mod.nu"

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# 입력했던 커멘드 오른쪽에 시간 기록
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = {||
  date now | format date "%F %H:%M:%S"
}