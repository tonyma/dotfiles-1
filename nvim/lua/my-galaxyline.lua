local momiji_colors = {
  black          = vim.fn['momiji#gui']('black'),
  red            = vim.fn['momiji#gui']('red'),
  green          = vim.fn['momiji#gui']('green'),
  yellow         = vim.fn['momiji#gui']('yellow'),
  blue           = vim.fn['momiji#gui']('blue'),
  magenta        = vim.fn['momiji#gui']('magenta'),
  cyan           = vim.fn['momiji#gui']('cyan'),
  white          = vim.fn['momiji#gui']('white'),
  bright_black   = vim.fn['momiji#gui']('bright_black'),
  bright_red     = vim.fn['momiji#gui']('bright_red'),
  bright_green   = vim.fn['momiji#gui']('bright_green'),
  bright_yellow  = vim.fn['momiji#gui']('bright_yellow'),
  bright_blue    = vim.fn['momiji#gui']('bright_blue'),
  bright_magenta = vim.fn['momiji#gui']('bright_magenta'),
  bright_cyan    = vim.fn['momiji#gui']('bright_cyan'),
  bright_white   = vim.fn['momiji#gui']('bright_white'),
  hard_black     = vim.fn['momiji#gui']('hard_black'),
  grayscale1     = vim.fn['momiji#gui']('grayscale1'),
  grayscale2     = vim.fn['momiji#gui']('grayscale2'),
  grayscale3     = vim.fn['momiji#gui']('grayscale3'),
  grayscale4     = vim.fn['momiji#gui']('grayscale4'),
  grayscale5     = vim.fn['momiji#gui']('grayscale5'),
}
local gl = require('galaxyline')
local gls = gl.section

local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end
  return false
end

local mode_colors = {
  n      = {momiji_colors.green,   momiji_colors.bright_green},
  no     = {momiji_colors.green,   momiji_colors.bright_green},
  i      = {momiji_colors.blue,    momiji_colors.bright_blue},
  ic     = {momiji_colors.blue,    momiji_colors.bright_blue},
  r      = {momiji_colors.cyan,    momiji_colors.bright_cyan},
  rm     = {momiji_colors.cyan,    momiji_colors.bright_cyan},
  ['r?'] = {momiji_colors.cyan,    momiji_colors.bright_cyan},
  v      = {momiji_colors.yellow,  momiji_colors.bright_yellow},
  [''] = {momiji_colors.yellow,  momiji_colors.bright_yellow},
  V      = {momiji_colors.yellow,  momiji_colors.bright_yellow},
  s      = {momiji_colors.magenta, momiji_colors.bright_magenta},
  S      = {momiji_colors.magenta, momiji_colors.bright_magenta},
  [''] = {momiji_colors.magenta, momiji_colors.bright_magenta},
  R      = {momiji_colors.magenta, momiji_colors.bright_magenta},
  Rv     = {momiji_colors.magenta, momiji_colors.bright_magenta},
  c      = {momiji_colors.red,     momiji_colors.bright_red},
  cv     = {momiji_colors.red,     momiji_colors.bright_red},
  ce     = {momiji_colors.red,     momiji_colors.bright_red},
  ['!']  = {momiji_colors.red,     momiji_colors.bright_red},
  t      = {momiji_colors.red,     momiji_colors.bright_red},
}

local mode_texts = {
  n      = "\u{E7C5}  ",
  no     = "\u{E7C5}  ",
  i      = "\u{FFAE6}  ",
  ic     = "\u{FFAE6}  ",
  r      = "\u{FF954}  ",
  rm     = "\u{FF954}  ",
  ['r?'] = "\u{FF954}  ",
  v      = "\u{FF761}  ",
  [''] = "\u{FF767}  ",
  V      = "\u{FF760}  ",
  s      = "\u{FFB51}  ",
  S      = "\u{FFB51}  ",
  ['^S'] = "\u{FFB51}  ",
  R      = "\u{FF954}  ",
  Rv     = "\u{FF954}  ",
  c      = "： ",
  cv     = "： ",
  ce     = "： ",
  t      = "\u{F120}  ",
  ['!']  = "\u{F120}  ",
}

gls.left[1] = {
  ViMode = {
    provider = function()
      -- auto change color according the vim mode
      local mode_color = mode_colors[vim.fn.mode()]
      local file_type = vim.api.nvim_buf_get_option(0, 'filetype')
      if file_type == 'fern' then
        local fern_mode = vim.api.nvim_buf_get_var(0, 'my_fern_mode')
        if fern_mode == 'operator' then
          mode_color = {momiji_colors.blue, momiji_colors.bright_blue}
        end
      end

      for index, component in next, gls.left do
        if index == 1 then
          for key in pairs(component) do
            vim.api.nvim_command('hi Galaxy' .. key .. '    guifg=' .. momiji_colors.black ..' guibg=' .. mode_color[1])
            vim.api.nvim_command('hi ' .. key .. 'Separator guifg=' .. mode_color[1]       ..' guibg=' .. mode_color[2])
          end
        else
          for key in pairs(component) do
            vim.api.nvim_command('hi Galaxy' .. key .. '    guifg=' .. momiji_colors.black ..' guibg=' .. mode_color[2])
            vim.api.nvim_command('hi ' .. key .. 'Separator guifg=' .. momiji_colors.black ..' guibg=' .. mode_color[2])
          end
        end
      end

      for _, component in next, gls.right do
        for key in pairs(component) do
          vim.api.nvim_command('hi Galaxy' .. key .. '    guifg=' .. momiji_colors.black ..' guibg=' .. mode_color[2])
          vim.api.nvim_command('hi ' .. key .. 'Separator guifg=' .. momiji_colors.black ..' guibg=' .. mode_color[2])
        end
      end

      return "\u{00A0}" .. mode_texts[vim.fn.mode()]
    end,
    separator = "\u{E0B0}\u{00A0}",
    highlight = {momiji_colors.black,momiji_colors.white,'bold'},
  },
}

gls.left[2] = {
  FileIcon = {
    provider = 'FileIcon',
    separator = "\u{00A0}\u{E0B1}\u{00A0}",
    condition = buffer_not_empty,
  },
}

-- get current dir
gls.left[3] = {
  CWD = {
    provider = function ()
      return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
    end,
    separator = "\u{E621} ",
  }
}

-- get current file name
gls.left[4] = {
  FileName = {
    provider = 'FileName',
  }
}

gls.right[1] = { GitBranch    = { provider = 'GitBranch',    icon = ' \u{E0A0} '  } }
gls.right[2] = { DiffAdd      = { provider = 'DiffAdd',      icon = ' \u{FF631} ' } }
gls.right[3] = { DiffModified = { provider = 'DiffModified', icon = ' \u{FF915} ' } }
gls.right[4] = { DiffRemove   = { provider = 'DiffRemove'  , icon = ' \u{FFC89} ' } }

-- TODO: show Ahead and Behind in current branch

gls.right[5] = { DiagnosticHint  = { provider = 'DiagnosticHint',  icon = '\u{F059}' } }
gls.right[6] = { DiagnosticInfo  = { provider = 'DiagnosticInfo',  icon = '\u{F05A}' } }
gls.right[7] = { DiagnosticWarn  = { provider = 'DiagnosticWarn',  icon = '\u{F06A}' } }
gls.right[8] = { DiagnosticError = { provider = 'DiagnosticError', icon = '\u{F057}' } }

vim.api.nvim_set_option('showmode', false)  -- galaxyline で表示するので、vim標準のモード表示は隠す
