local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local pickers = require('telescope.pickers')
local utils = require('telescope.utils')

local conf = require('telescope.config').values

local my = {}

-- Built-in actions
local actions = require('telescope.actions')

-- Setup    =================================================================================
require('telescope').setup{
  defaults = {
    set_env = { ['COLORTERM'] = 'truecolor' },
    -- Global remapping
    mappings = {
      i = {
        ["<cr>"] = actions.select_default + actions.center,
        ["<c-space>"] = actions.toggle_selection,
        ["<esc>"] = actions.close,
      },
      n = {
        ["<c-p>"] = actions.move_selection_previous,
        ["<c-n>"] = actions.move_selection_next,
        ["<esc>"] = actions.close,
        ["<space>"] = actions.toggle_selection,
      },
    },
    shorten_path = false,
  }
}

-- Styles   =================================================================================

my.setup_highlight = function()
  local palette = vim.g.momiji_palette
  local highlight = vim.fn['MomijiHighlight']
  highlight('TelescopeSelection', {fg = palette.black, bg = palette.blue})
  highlight('TelescopeMultiSelection', {fg = palette.black, bg = palette.lightblue})
  highlight('TelescopeMatching', {fg = palette.lightyellow})
end

if vim.g.colors_name == 'momiji' then
  my.setup_highlight()
else
  vim.cmd[[ autocmd ColorScheme momiji ++once lua require('my-telescope').setup_highlight() ]]
end

-- Keymaps =================================================================================

vim.api.nvim_set_keymap('n', '<leader>ff',  '<cmd>lua require("telescope.builtin").find_files()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>f:',  '<cmd>lua require("telescope.builtin").command_history()<cr>',    { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fgs', '<cmd>lua require("telescope.builtin").git_status()<cr>',    { noremap = true, silent = true })
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

local buffers_cmd = [[lua require("my-telescope").buffers()]]
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>' .. buffers_cmd .. '<cr>',    { noremap = true, silent = true })

local git_branches_cmd = [[lua require("my-telescope").git_branches()]]
vim.api.nvim_set_keymap('n', '<leader>fgb', '<cmd>' .. git_branches_cmd .. '<cr>',    { noremap = true, silent = true })

-- Pickers ==================================================================================
my.git_recent = function(o)
  local opts = o or {}
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

my.git_branches = function(opts)
  opts = opts or {}
  opts.attach_mappings = function(_, map)
    actions.select_default:replace(actions.git_switch_branch)
    map('i', '<c-x>', actions.git_checkout)
    map('n', '<c-x>', actions.git_checkout)

    map('i', '<c-t>', actions.git_track_branch)
    map('n', '<c-t>', actions.git_track_branch)

    map('i', '<c-r>', actions.git_rebase_branch)
    map('n', '<c-r>', actions.git_rebase_branch)

    map('i', '<c-a>', actions.git_create_branch)
    map('n', '<c-a>', actions.git_create_branch)

    map('i', '<c-d>', actions.git_delete_branch)
    map('n', '<c-d>', actions.git_delete_branch)
    return true
  end
  require'telescope.builtin'.git_branches(opts)
end

my.buffers = function(opts)
  local action_state = require('telescope.actions.state')
  opts = opts or {}
  -- opts.previewer = false
  -- opts.sort_lastused = true
  -- opts.show_all_buffers = true
  -- opts.shorten_path = false
  opts.attach_mappings = function(prompt_bufnr, map)
    local delete_buf = function()
      local current_picker = action_state.get_current_picker(prompt_bufnr)
      local multi_selections = current_picker:get_multi_selection()

      if next(multi_selections) == nil then
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.api.nvim_buf_delete(selection.bufnr, {force = true})
      else
        actions.close(prompt_bufnr)
        for _, selection in ipairs(multi_selections) do
          vim.api.nvim_buf_delete(selection.bufnr, {force = true})
        end
      end
    end
    map('i', '<c-d>', delete_buf)
    map('n', '<c-d>', delete_buf)
    return true
  end
  require('telescope.builtin').buffers(opts)
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
