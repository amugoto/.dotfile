return {
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = false, -- 시작 시 바로 로드
    priority = 1000, -- 다른 플러그인보다 먼저 로드되도록 우선순위 설정
    config = function()
      vim.cmd('colorscheme github_dark_dimmed')
    end
  } 
}