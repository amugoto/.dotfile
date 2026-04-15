return {
  {
		-- 라인 옮기기 가능하게 해주는 플러그인 (단축키 option + 방향키 위/아래)
		"fedepujol/move.nvim",
		keys = {
			{
				"<M-Down>",
				":MoveLine(1)<CR>",
				mode = "n",
				noremap = true,
				silent = true
			},
			{
				"<M-Up>",
				":MoveLine(-1)<CR>",
				mode = "n",
				noremap = true,
				silent = true
			},
			{
				"<M-Down>",
				":MoveBlock(1)<CR>",
				mode = "v",
				noremap = true,
				silent = true
			},
			{
				"<M-Up>",
				":MoveBlock(-1)<CR>",
				mode = "v",
				noremap = true,
				silent = true
			},
		},
		config = true
	}
}