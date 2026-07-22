return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    keys = {
      {
        "<leader>mt",
        function()
          local window = vim.api.nvim_get_current_win()
          local preview_active = vim.w[window].render_markdown_preview_active

          if preview_active then
            vim.cmd("RenderMarkdown buf_disable")
            vim.wo[window].wrap = vim.w[window].render_markdown_preview_wrap
            vim.w[window].render_markdown_preview_active = false
          else
            vim.w[window].render_markdown_preview_wrap = vim.wo[window].wrap
            vim.wo[window].wrap = false
            vim.cmd("RenderMarkdown buf_enable")
            vim.w[window].render_markdown_preview_active = true
          end
        end,
        desc = "Toggle Markdown Render",
        ft = "markdown",
      },
    },
    opts = {
      enabled = false,

      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = {},
      },
      checkbox = {
        enabled = false,
      },
      anti_conceal = {
        enabled = false,
      },
      win_options = {
        conceallevel = {
          default = vim.o.conceallevel,
          rendered = 3,
        },
        concealcursor = {
          default = vim.o.concealcursor,
          rendered = "nivc",
        },
      },
      pipe_table = {
        cell = "trimmed",
        padding = 0,
        min_width = 3,
        style = "full",
      },
    },
  },
}
