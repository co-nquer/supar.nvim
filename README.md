# `supar.nvim`

[sup]er [ar]gument list provides a floating window to modify your argument list
(see `:help args`). Combined with (neo)vims build-in functionallity for the 
argument list this makes working with multiple files sup[a]r.

**Some cool (neo)vim built-ins for args:**
1. Run commands on args: `:argdo`
2. Navigate args: `:argu [N]`, `:n`, `:N`, `:first`, `:last`
3. Add current file to args: `:arga %`
4. View args: `:al`, 
5. View difference between args: `:vert al | windo difft`

Also note that the argument list gets automatically populated with the files you pass when evoking neovim (hence the name *args*). For example, `nvim *.md` fills the arg list with all the files that match the pattern `*.md` in the current working directory.

# Usage

Open the floating window
```lua
require("supar").open_supar()
```
Then simply close the window (`:q`) to update the list accordingly. I recommend
the keybindings below.

## Suggested Keybindings
```lua
-- Toggle Arg List
vim.keymap.set("n", "<leader>a", function()
  local supar = require("supar").open_supar()

  vim.keymap.set("n", "<leader>a", function()
    vim.api.nvim_win_close(supar.win, true)
  end, {
    buffer = supar.buf
  })
end)

-- Jump to arg [i]
for i = 1, 5 do
  vim.keymap.set("n", "<leader>" .. i, ":argu " .. i .. "<CR>")
end

-- Next/Previous arg
vim.keymap.set("n", "<leader>0", ":next <CR>")
vim.keymap.set("n", "<leader>9", ":Next <CR>")
```
