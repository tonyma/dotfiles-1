vim.api.nvim_set_keymap('n', '<Leader>ff', '<CMD>lua require("telescope.builtin").find_files()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fb', '<CMD>lua require("telescope.builtin").buffers()<CR>',    { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fgs', '<CMD>lua require("telescope.builtin").git_status()<CR>',    { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fgb', '<CMD>lua require("telescope.builtin").git_branches()<CR>',    { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fgc', '<CMD>lua require("telescope.builtin").git_commits()<CR>',    { noremap = true, silent = true })
-- TODO: git-edit

-- Built-in actions
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

