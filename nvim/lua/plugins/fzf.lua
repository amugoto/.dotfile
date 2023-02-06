
require('fzf-lua').setup({
  winopts = {
    preview = { default = 'bat' }
  },
  file_ignore_patterns = {
    "%.git$",
    "node_modules",
    "%.lock$",
  }
})