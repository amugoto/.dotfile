local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end


vim.g.mapleader = ','


-----------------------------------------------------------
-- Neovim shortcuts
-----------------------------------------------------------

map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')


-----------------------------------------------------------
-- Applications and Plugins shortcuts
-----------------------------------------------------------

-- NvimTree
map('n', '<leader>n', ':NvimTreeToggle<CR>')        -- open/close
map('n', '<leader>r', ':NvimTreeRefresh<CR>')       -- refresh
map('n', '<leader>f', ':NvimTreeFindFile<CR>')      -- search file

-- fzf
map('n', '<C-p>', ":FzfLua files<CR>")                 -- find file
map('n', '<C-o>', ":FzfLua oldfiles<CR>")              -- opened files history
map('n', '<C-f>', ":FzfLua live_grep debug=true<CR>")  -- keyword search