local autocmd = vim.api.nvim_create_autocmd   -- Create autocommand


-- local modifiedBufs = function(bufs)
--   local t = 0
--   for k,v in pairs(bufs) do
--       if v.name:match("NvimTree_") == nil then
--           t = t + 1
--       end
--   end
--   return t
-- end

-- autocmd("BufEnter", {
--   nested = true,
--   callback = function()
--       if #vim.api.nvim_list_wins() == 1 and
--       vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil and
--       modifiedBufs(vim.fn.getbufinfo({bufmodified = 1})) == 0 then
--           vim.cmd "quit"
--       end
--   end
-- })