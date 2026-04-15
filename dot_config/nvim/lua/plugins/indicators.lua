return {
	{
		-- 커서가 위치한 단어(예: 변수 이름)에 자동으로 하이라이트 적용
		"RRethy/vim-illuminate"
	},
	{
		-- 단어 점프라고 해야되나?.. 문자위에 커서 놓고 t/T 혹은 f/F 누르고 특정 색으로 바뀐 스펠링 눌러보면 바로 이해됩니다.
		"jinh0/eyeliner.nvim",
		lazy = false,
		opts = { highlight_on_key = true, dim = true }
	},
	{
		-- CURSOR MOVEMENT HIGHLIGHTER
		"DanilaMihailov/beacon.nvim",
		opts = {
			min_jump = 5,
			speed = 10,
		},
	},
	{
		-- 텍스트를 복사(yy)할 때 해당 라인을 일시적으로 강조 표시(highlight)해 주는 플러그인
		"machakann/vim-highlightedyank"
	}
}
