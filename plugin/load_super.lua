vim.api.nvim_create_user_command("Supar", function()
  require("supar").open_supar()
end, {})
