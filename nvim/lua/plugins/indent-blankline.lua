vim.opt.termguicolors = true
vim.cmd [[highlight IndentBlanklineIndent1 guifg=#FFD700 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guifg=#DA70D6 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent3 guifg=#ff9900 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent4 guifg=#87CEFA gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent5 guifg=#80ffbb gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent6 guifg=#FF628C gui=nocombine]]

-- vim.opt.list = true
-- vim.opt.listchars:append "space:⋅"    -- space bar 표시
-- vim.opt.listchars:append "eol:↴"      -- enter 표시

require("indent_blankline").setup {
  show_current_context = true,
  show_current_context_start = true,
  show_trailing_blankline_indent = false,
  space_char_blankline = " ",
  char_highlight_list = {
    "IndentBlanklineIndent1",
    "IndentBlanklineIndent2",
    "IndentBlanklineIndent3",
    "IndentBlanklineIndent4",
    "IndentBlanklineIndent5",
    "IndentBlanklineIndent6",
  },
}