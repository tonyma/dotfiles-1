vim.api.nvim_set_keymap('n', '<Leader>fp', '<CMD>lua require("telescope").extensions.gogh.list()<CR>',  { noremap = true, silent = true })

require('telescope').setup{
  extensions = {
    gogh = {
      shorten_path = false
    }
  }
}
require('telescope').load_extension('gogh')
