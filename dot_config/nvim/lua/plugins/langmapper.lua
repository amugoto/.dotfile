return {
  {
    "Wansmer/langmapper.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local langmapper = require("langmapper")

      langmapper.setup({
        -- langmapper의 기본 배열과 한글 배열은 문자 순서와 길이가 완전히 같아야 한다.
        default_layout = [[~QWERTYUIOP{}|ASDFGHJKL:"ZXCVBNM<>?`qwertyuiop[]asdfghjkl;'zxcvbnm,./]],
        layouts = {
          korean = {
            id = "com.apple.inputmethod.Korean.2SetKorean",
            layout = [[~ㅃㅉㄸㄲㅆㅛㅕㅑㅒㅖ{}|ㅁㄴㅇㄹㅎㅗㅓㅏㅣ:"ㅋㅌㅊㅍㅠㅜㅡ<>?`ㅂㅈㄷㄱㅅㅛㅕㅑㅐㅔ[]ㅁㄴㅇㄹㅎㅗㅓㅏㅣ;'ㅋㅌㅊㅍㅠㅜㅡ,./]],
          },
        },
        use_layouts = { "korean" },
        os = {
          Darwin = {
            get_current_layout_id = function()
              return vim.trim(vim.fn.system("/opt/homebrew/bin/macism"))
            end,
          },
        },
      })

      -- LazyVim이 기본 단축키를 모두 등록한 뒤에도 한글 보조 매핑을 만든다.
      -- 시작 순서에 따라 누락되던 <leader> 매핑을 한 번의 입력으로 동작하게 한다.
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        once = true,
        callback = function()
          vim.schedule(function()
            langmapper.automapping({ global = true, buffer = true })
          end)
        end,
      })

      -- 한글 2벌식의 단독 자음은 다음 입력이 와야 터미널에 확정된다.
      -- leader를 누르는 즉시 ABC로 전환해 다음 단축키 키를 한 번에 전달한다.
      local leader_input_ns = vim.api.nvim_create_namespace("codex_leader_input_source")
      vim.on_key(nil, leader_input_ns)
      vim.on_key(function(_, typed)
        if vim.fn.mode(1) == "n" and typed == vim.g.mapleader then
          vim.fn.system({ "/opt/homebrew/bin/macism", "com.apple.keylayout.ABC" })
        end
      end, leader_input_ns)
    end,
  },
}
