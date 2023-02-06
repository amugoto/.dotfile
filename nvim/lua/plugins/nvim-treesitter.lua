require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
  },
  sync_install = false,
  ensure_installed = {
    'css',
    'lua',
    'php',
    'tsx',
    'bash',
    'html',
    'json',
    'rust',
    'yaml',
    'markdown',
    'javascript',
    'typescript',
  }
})