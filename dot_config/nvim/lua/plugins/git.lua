return {
  {
		-- 커밋 메세지 플로팅 띄워서 볼수 있게 해주는 플러그인
		"lsig/messenger.nvim",
		opts = {
			border = "rounded"
		},
		keys = {
			{
				"<leader><leader>gc",
				"<Cmd>MessengerShow<CR>",
				desc = "show commit in floating window",
				mode = "n",
				noremap = true,
				silent = true
			}
		},
	},
  -- {
  --   "sindrets/diffview.nvim"
  -- },
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
  }

}