return {
	{
		-- 괄호 입력하면 닫는 괄호 자동으로 입력되고 커서가 괄호 사이에 위치하게 해주는 플러그인
		"windwp/nvim-autopairs",
		config = true,
	},
	{
		-- selection 괄호 쓰워 주려고 사용함.
		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				surrounds = {
					-- 모든 괄호에서 공백 제거
					["("] = {
						add = { "(", ")" },
					},
					["["] = {
						add = { "[", "]" },
					},
					["{"] = {
						add = { "{", "}" },
					}
				}
			})
		end
	},
}