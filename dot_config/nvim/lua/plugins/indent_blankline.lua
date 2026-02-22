return {
  { import = "lazyvim.plugins.extras.ui.indent-blankline" },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = function(_, opts)
      local indent_hl = {
        "Indent1",
        "Indent2",
        "Indent3",
        "Indent4",
        "Indent5",
        "Indent6",
      }

      local scope_hl = {
        "Scope1",
        "Scope2",
        "Scope3",
        "Scope4",
        "Scope5",
        "Scope6",
      }

      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        -- 일반 들여쓰기(옅게)
        vim.api.nvim_set_hl(0, "Indent1", { fg = "#5a4f1a", nocombine = true })
        vim.api.nvim_set_hl(0, "Indent2", { fg = "#5a3d5a", nocombine = true })
        vim.api.nvim_set_hl(0, "Indent3", { fg = "#5a4422", nocombine = true })
        vim.api.nvim_set_hl(0, "Indent4", { fg = "#345066", nocombine = true })
        vim.api.nvim_set_hl(0, "Indent5", { fg = "#2f5d4b", nocombine = true })
        vim.api.nvim_set_hl(0, "Indent6", { fg = "#6a3a4a", nocombine = true })

        -- 현재 scope(진하게, depth별)
        vim.api.nvim_set_hl(0, "Scope1", { fg = "#FFD700", bold = true, nocombine = true })
        vim.api.nvim_set_hl(0, "Scope2", { fg = "#DA70D6", bold = true, nocombine = true })
        vim.api.nvim_set_hl(0, "Scope3", { fg = "#FF9900", bold = true, nocombine = true })
        vim.api.nvim_set_hl(0, "Scope4", { fg = "#87CEFA", bold = true, nocombine = true })
        vim.api.nvim_set_hl(0, "Scope5", { fg = "#80FFBB", bold = true, nocombine = true })
        vim.api.nvim_set_hl(0, "Scope6", { fg = "#FF628C", bold = true, nocombine = true })
      end)

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, function(_, bufnr, scope, _)
        local start_row = select(1, scope:start())
        local indent_cols = vim.fn.indent(start_row + 1)

        local sw = vim.api.nvim_get_option_value("shiftwidth", { buf = bufnr })
        if sw == 0 then
          sw = vim.api.nvim_get_option_value("tabstop", { buf = bufnr })
        end

        return math.floor(indent_cols / sw) + 1
      end)


      opts.indent = vim.tbl_deep_extend("force", opts.indent or {}, {
        highlight = indent_hl,
        char = "│",
        tab_char = "│",
      })

      opts.scope = vim.tbl_deep_extend("force", opts.scope or {}, {
        enabled = true,
        highlight = scope_hl,
        show_start = false,
        show_end = false,
        include = {
          node_type = {
            lua = { "table_constructor" },
          },
        },
      })

      opts.whitespace = vim.tbl_deep_extend("force", opts.whitespace or {}, {
        remove_blankline_trail = true,
      })

      
      return opts
    end,
  },
}


-- -- /Users/ingon/.config/nvim/lua/plugins/indent_guides.lua
-- return {
--   { import = "lazyvim.plugins.extras.ui.indent-blankline" },

--   {
--     "lukas-reineke/indent-blankline.nvim",
--     main = "ibl",
--     opts = function(_, opts)
--       local highlight = {
--         "IndentBlanklineIndent1",
--         "IndentBlanklineIndent2",
--         "IndentBlanklineIndent3",
--         "IndentBlanklineIndent4",
--         "IndentBlanklineIndent5",
--         "IndentBlanklineIndent6",
--       }

--       local hooks = require("ibl.hooks")
--       hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
--         vim.api.nvim_set_hl(0, "IndentBlanklineIndent1", { fg = "#FFD700", nocombine = true })
--         vim.api.nvim_set_hl(0, "IndentBlanklineIndent2", { fg = "#DA70D6", nocombine = true })
--         vim.api.nvim_set_hl(0, "IndentBlanklineIndent3", { fg = "#ff9900", nocombine = true })
--         vim.api.nvim_set_hl(0, "IndentBlanklineIndent4", { fg = "#87CEFA", nocombine = true })
--         vim.api.nvim_set_hl(0, "IndentBlanklineIndent5", { fg = "#80ffbb", nocombine = true })
--         vim.api.nvim_set_hl(0, "IndentBlanklineIndent6", { fg = "#FF628C", nocombine = true })
--       end)

--       opts.indent = vim.tbl_deep_extend("force", opts.indent or {}, {
--         highlight = highlight,
--       })

--       opts.scope = vim.tbl_deep_extend("force", opts.scope or {}, {
--         enabled = true,      -- show_current_context = true
--         show_start = true,   -- show_current_context_start = true
--         show_end = false,    -- 필요하면 true로
--       })

      

--       return opts
--     end,
--   },
-- }
