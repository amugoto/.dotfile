-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local g = vim.g
local opt = vim.opt

opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.swapfile = false
opt.backup = false
opt.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"

-----------------------------------------------------------
-- UI
-----------------------------------------------------------
opt.number = true
opt.relativenumber = false
opt.showmatch = true
opt.splitright = true
opt.splitbelow = true
opt.smartcase = true
opt.cursorline = true
opt.ignorecase = true
opt.wrapscan = false
opt.hlsearch = true
opt.termguicolors = true
opt.laststatus = 2
opt.paste = true

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-----------------------------------------------------------
-- Encoding
-----------------------------------------------------------
opt.fileencoding = "utf-8"
opt.encoding = "utf8"
opt.langmap =
  "ㅁㅠㅊㅇㄷㄹㅎㅗㅑㅓㅏㅣㅡㅜㅐㅔㅂㄱㄴㅅㅕㅍㅈㅌㅛㅋ;abcdefghijklmnopqrstuvwxyz"

-- Disable builtin plugins
local disabled_built_ins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
  "tutor",
  "rplugin",
  "synmenu",
  "optwin",
  "compiler",
  "bugreport",
  "ftplugin",
}

for _, plugin in pairs(disabled_built_ins) do
  g["loaded_" .. plugin] = 1
end
