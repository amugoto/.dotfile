return {
  {
    "folke/which-key.nvim",
    opts = {
      -- langmapper가 만든 한글 보조 매핑은 실제 실행용으로는 유지하되,
      -- 안내창에는 원본 영문 매핑만 보여 준다.
      filter = function(mapping)
        return not (type(mapping.desc) == "string" and mapping.desc:find(" LM (", 1, true))
      end,
      replace = {
        key = {
          function(key)
            return require("langmapper.utils").translate_keycode(key, "default", "korean")
          end,
          function(key)
            return require("which-key.view").format(key)
          end,
        },
      },
    },
  },
}
