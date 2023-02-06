local command = function(name, command, opts)
  local options = { nargs = 0 }

  if opts then
    options = opts
  end
  vim.api.nvim_create_user_command(name, command, options)
end

-- fzf - git
command('G', 'FzfLua git_status')        -- git status view
command('GC', 'FzfLua git_commits')      -- git commit log view
command('GBC', 'FzfLua git_bcommits')    -- git current buffer commit log view

command('Comment', ':execute "\'<,\'>normal! <C-v>0I" . <f-args> . "<Esc><Esc>"', { range, nargs = 1 })
