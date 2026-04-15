local picker_exclude = {
  "node_modules/**",
  "*.jpg",
  "*.png",
  "build/**",
  "dist/**",
  ".git/**",
  ".svn/**",
  ".DS_Store",
  "package-lock.json",
  "yarn-lock.json",
  "yarn.lock",
}

return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        -- 기본적으로 숨김 파일을 보여줌
        -- hidden = true,
        -- gitignore 된 파일도 보고 싶다면 true로 설정
        -- ignored = true,
        replace_netrw = true,
      },

      picker = {
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
          },
          files = {
            exclude = picker_exclude,
          },
          grep = {
            exclude = picker_exclude,
          },
        },
      },
    },
  },
}
