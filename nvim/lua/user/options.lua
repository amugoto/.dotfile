local g = vim.g
local set = vim.opt


set.mouse = 'a'  
set.clipboard = 'unnamedplus'
set.swapfile = false
set.backup = false


-----------------------------------------------------------
-- UI
-----------------------------------------------------------
set.number = true
set.showmatch = true
set.splitright = true
set.splitbelow = true
set.smartcase = true
set.cursorline = true
set.ignorecase = true
set.wrapscan = false
set.hlsearch = true
set.termguicolors = true
set.laststatus = 2
set.paste = true

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
set.tabstop = 2
set.shiftwidth = 2
set.softtabstop = 2
set.expandtab = true
set.smartindent = true

-----------------------------------------------------------
-- Encoding
-----------------------------------------------------------
set.fileencoding = "utf-8"
set.encoding = "utf8"
set.langmap = "ㅁㅠㅊㅇㄷㄹㅎㅗㅑㅓㅏㅣㅡㅜㅐㅔㅂㄱㄴㅅㅕㅍㅈㅌㅛㅋ;abcdefghijklmnopqrstuvwxyz"

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------

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
