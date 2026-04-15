return {
  {
		-- 색상코드 인지해서 해당 색상 보여주는 플러그인.
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		config = function()
			require("colorizer").setup()
    end
	}
}