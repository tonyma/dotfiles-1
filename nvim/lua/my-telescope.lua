local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local pickers = require('telescope.pickers')
local utils = require('telescope.utils')

local conf = require('telescope.config').values

-- Built-in actions
local actions = require('telescope.actions')

-- Setup    =================================================================================
require('telescope').setup{
  defaults = {
    set_env = { ['COLORTERM'] = 'truecolor' },
    -- Global remapping
    mappings = {
      i = {
        ["<CR>"] = actions.select_default + actions.center,
        ["<esc>"] = actions.close,
      },
      n = {
        ["<esc>"] = actions.close,
      },
    },
    shorten_path = true,
  }
}

-- Styles   =================================================================================

local M = {}

M.setupTelescopeHighlight = function()
  local palette = vim.g.momiji_palette
  local highlight = vim.fn['MomijiHighlight']
  highlight('TelescopeSelection', {fg = palette.black, bg = palette.blue})
  highlight('TelescopeMultiSelection', {fg = palette.black, bg = palette.lightblue})
  highlight('TelescopeMatching', {fg = palette.lightyellow})
end

if vim.g.colors_name == 'momiji' then
  M.setupTelescopeHighlight()
else
  vim.cmd[[ autocmd ColorScheme momiji ++once lua require('my-galaxyline').setupTelescopeHighlight() ]]
end

-- Commands =================================================================================

vim.api.nvim_set_keymap('n', '<leader>ff',  '<cmd>lua require("telescope.builtin").find_files()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb',  '<cmd>lua require("telescope.builtin").buffers()<cr>',    { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>f:',  '<cmd>lua require("telescope.builtin").command_history()<cr>',    { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fgs', '<cmd>lua require("telescope.builtin").git_status()<cr>',    { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fgb', '<cmd>lua require("telescope.builtin").git_branches()<cr>',    { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fgc', '<cmd>lua require("telescope.builtin").git_commits()<cr>',    { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>flr', '<cmd>lua require("telescope.builtin").lsp_references()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fld', '<cmd>lua require("telescope.builtin").lsp_document_symbols()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>flw', '<cmd>lua require("telescope.builtin").lsp_workspace_symbols()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fla', '<cmd>lua require("telescope.builtin").lsp_code_actions()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>fla', '<cmd>lua require("telescope.builtin").lsp_range_code_actions()<cr>', { noremap = true, silent = true })

local config_cmd = [[lua require("my-telescope").config()]]
vim.cmd('command! EditConfig ' .. config_cmd)
vim.api.nvim_set_keymap('n', '<leader><leader>c', '<cmd>' .. config_cmd .. '<cr>', { noremap = true, silent = true })

local packer_cmd = [[lua require("my-telescope").packer()]]
vim.cmd('command! EditPacker ' .. packer_cmd)
vim.api.nvim_set_keymap('n', '<leader><leader>p', '<cmd>' .. packer_cmd .. '<cr>', { noremap = true, silent = true })

local recent_cmd = [[lua require("my-telescope").git_recent()]]
vim.cmd('command! EditRecent ' .. recent_cmd)
vim.api.nvim_set_keymap('n', '<leader>fgr', '<cmd>' .. recent_cmd .. '<cr>',    { noremap = true, silent = true })

local my = {}
my.git_recent = function(opts)
  local opts = opts or {}
  local depth = utils.get_default(opts.depth, 5)

  if opts.cwd then
    opts.cwd = vim.fn.expand(opts.cwd)
  end

  opts.entry_maker = opts.entry_maker or make_entry.gen_from_file(opts)

  pickers.new(opts, {
    prompt_title = 'Git Recent',
    finder = finders.new_oneshot_job(
      {'git', 'diff', '--name-only', depth and 'HEAD~' .. depth or 'HEAD'},
      opts
    ),
    previewer = conf.file_previewer(opts),
    sorter = conf.file_sorter(opts),
  }):find()
end

my.packer = function()
require("telescope.builtin").find_files({
  search_dirs = {
    "~/.local/share/nvim/site/pack/packer/opt",
    "~/.local/share/nvim/site/pack/packer/start",
  },
  cwd = "~/.local/share/nvim/site/pack/packer",
})
end

my.config = function()
  require("telescope.builtin").git_files({cwd = "~/.config"})
end
return my
