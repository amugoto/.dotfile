return {
  {
    "keaising/im-select.nvim",
    main = "im_select",
    opts = {
      default_command = "/opt/homebrew/bin/macism",
      default_im_select = "com.apple.keylayout.ABC",
      set_default_events = { "InsertLeave", "CmdlineLeave" },
      set_previous_events = { "InsertEnter" },
    },
  },
}
