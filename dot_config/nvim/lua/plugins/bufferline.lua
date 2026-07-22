return {
  {
    "akinsho/bufferline.nvim",
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        always_show_bufferline = true, -- 파일이 1개만 열려 있어도 항상 탭 표시
        diagnostics = "nvim_lsp",
        separator_style = "thin",
      }
    },
  },
}
