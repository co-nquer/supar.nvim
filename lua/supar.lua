local M = {}

--- Spawns a floating window with a scratch buffer containing the argument list
--- (see `:help args`) in its current order. Modify the lines and quit the buffer
--- to update the list.
M.open_supar = function()
  -- Get args
  local args = vim.api.nvim_exec('silent echo argv()', true)

  -- Parse args
  local parsed = {}
  for _, arg in ipairs(vim.split(args:sub(2, -2), ", ")) do
    table.insert(parsed, arg:sub(2, -2))
  end

  -- Display Argument List in a floating window
  local width = 60
  local height = 10
  local buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  local win = vim.api.nvim_open_win(buf, true, {
    width = width,
    height = height,

    -- center the window
    relative = "editor",
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),

    style = "minimal",
    border = "rounded",
    title = "Argument List",
    title_pos = "center",
  })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, parsed)
  -- Style options
  vim.api.nvim_set_option_value('number', true, { win = win })
  -- Provide customizable highlight group for the floating window
  -- vim.api.nvim_set_option_value(
  --   'winhighlight',
  --   'NormalFloat:Supar,FloatBorder:Supar,FloatTitle:Supar',
  --   { win = win }
  -- )

  -- Update the argument list when closing the buffer
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = buf,
    callback = function()
      -- Get lines
      local new_args = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

      -- Check if update is required
      -- ??? Is there even a problem in resetting the arg list to the same value
      local nothing_has_changed = true
      for index, new_arg in ipairs(new_args) do
        if new_arg ~= parsed[index] then
          nothing_has_changed = false
          break
        end
      end
      if nothing_has_changed then
        -- Quit before updating
        vim.print("No change in the argument list")
        return
      end

      -- Update arg list
      local concat = table.concat(new_args, " ")
      if concat:match("^%s*$") then
        vim.print("Emptying the argument list")
        vim.cmd("%argdelete")
      else
        vim.cmd("args " .. concat)
      end
    end
  })

  return { buf = buf, win = win }
end

return M
