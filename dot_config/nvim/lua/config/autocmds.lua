-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- git commit 으로 상세 내용 COMMIT_EDITMSG 파일에 작성 시 자동 줄바꿈 되도록 설정
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = "COMMIT_EDITMSG",
  callback = function()
    vim.schedule(function()
      vim.opt_local.textwidth = 80
    end)
  end,
})

-- mdx 확장자 markdown으로 인식하도록 설정
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.mdx" },
  command = "set filetype=markdown",
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- vim-illuminate(커서 아래 있는 단어랑 같은 단어들 전부 강조 표시) 색상 설정
    vim.api.nvim_set_hl(0, "illuminatedWord", { fg = "#063970", bg = "#76b5c5" })
    vim.api.nvim_set_hl(0, "LspReferenceText", { fg = "#FFFF00", bg = "#76b5c5" })
    vim.api.nvim_set_hl(0, "LspReferenceWrite", { fg = "#FFFF00", bg = "#76b5c5" })
    vim.api.nvim_set_hl(0, "LspReferenceRead", { fg = "#FFFF00", bg = "#76b5c5" })

    -- eyeliner 색상 설정
    vim.api.nvim_set_hl(0, "EyelinerPrimary", { fg = "#FF0000", bold = true, underline = true })
    vim.api.nvim_set_hl(0, "EyelinerSecondary", { fg = "#FFFF00", underline = true })
  end,
})

-- markdown,txt 등 파일에서 spell check 끄기
vim.api.nvim_clear_autocmds({ group = "lazyvim_wrap_spell" })

-- 줄이 길어도 오른쪽으로 흘러가지 않고, 창 너비에 맞춰 자동 줄 바꿈 함.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("WrapLineInMarkdown", { clear = true }),
  pattern = { "markdown" },
  command = "setlocal wrap",
})

-- 스크롤바 색상
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  group = vim.api.nvim_create_augroup("ScrollbarHandleHighlight", { clear = true }),
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "ScrollbarHandle", { bg = "#8ec07c" })
  end,
})

vim.filetype.add({
  filename = {
    ["Brewfile"] = "ruby",
  },
  pattern = {
    [".*/Brewfile"] = "ruby",
    [".*/Brewfile.*"] = "ruby",
  },
})
