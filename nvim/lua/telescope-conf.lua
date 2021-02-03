vim.api.nvim_set_keymap('n', '<Leader>ff', '<CMD>lua require("telescope.builtin").find_files()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fg', '<CMD>lua require("telescope.builtin").live_grep()<CR>',  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fb', '<CMD>lua require("telescope.builtin").buffers()<CR>',    { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fh', '<CMD>lua require("telescope.builtin").help_tags()<CR>',  { noremap = true, silent = true })

-- Built-in actions
local transform_mod = require('telescope.actions.mt').transform_mod

local actions = require('telescope.actions')

-- Setup
require('telescope').setup{
  defaults = {
    set_env = { ['COLORTERM'] = 'truecolor' },
    -- Global remapping
    mappings = {
      i = {
        ["<CR>"] = actions.goto_file_selection_edit + actions.center,
        ["<esc>"] = actions.close,
      },
      n = {
        ["<esc>"] = actions.close,
      },
    },
  }
}
