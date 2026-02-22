return {
  {
    -- multi cursor
    'mg979/vim-visual-multi',
    branch = "master",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>",
        ["Select All"] = "<C-S-l>",
      }

      vim.g.VM_Cursor_hl = "Search"
      vim.g.VM_Extend_hl = "IncSearch"
      vim.g.VM_Insert_hl = "DiffText"
      vim.g.VM_Mono_hl = "PmenuSel"
      vim.g.VM_highlight_matches = "underline"
    end,
  }
}