local gl = require('galaxyline')
local provider_vcs = require('galaxyline.provider_vcs')
local gls = gl.section
local debounce = require('my-debounce')

local reload = debounce.throttle_trailing(require("galaxyline").load_galaxyline, 1 * 1000, true)

local modeTexts = {
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

local modeColors = {}
local palette = {}

-- モードを表示してモードに応じたHighlightを設定するprovider
local function modeProvider()
  -- 色のセット {deep = ..., light = ...} を得る
  local modeColor = modeColors[vim.fn.mode()]
  local fileType = vim.api.nvim_buf_get_option(0, 'filetype')
  if fileType == 'fern' then
    local fernMode = vim.b.my_fern_mode
    if fernMode == 'operate' then
      modeColor = {deep = palette.magenta, light = palette.lightmagenta}
    end
  end

  -- highlightを用意する
  vim.cmd('hi GalaxyDeep     guifg=' .. palette.black  .. ' guibg=' .. modeColor.deep)
  vim.cmd('hi GalaxyDeepSep  guifg=' .. modeColor.deep .. ' guibg=' .. modeColor.light)
  vim.cmd('hi GalaxyLight    guifg=' .. palette.black  .. ' guibg=' .. modeColor.light)
  vim.cmd('hi GalaxyLightSep guifg=' .. palette.black  .. ' guibg=' .. modeColor.light)

  return "\u{00A0}" .. modeTexts[vim.fn.mode()]
end

-- 空文字を返すprovider
local function emptyProvider() return '' end

-- Gitのディレクトリにいるかどうか
local function isinGitDir()
  local cwd = vim.fn.getcwd()
  local result = provider_vcs.get_git_dir(cwd)
  if not result then
    return false
  end
  return true
end

-- 現在のディレクトリ名を得るprovider
local function cwdProvider ()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
end

-- バッファがファイルを開いているかどうか
local function bufferHasFile()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end
  return false
end

local M = {}

M.setup = function(newPalette)
  palette = newPalette
  modeColors = {
    n      = {deep = palette.green,   light = palette.lightgreen},
    no     = {deep = palette.green,   light = palette.lightgreen},
    i      = {deep = palette.blue,    light = palette.lightblue},
    ic     = {deep = palette.blue,    light = palette.lightblue},
    r      = {deep = palette.cyan,    light = palette.lightcyan},
    rm     = {deep = palette.cyan,    light = palette.lightcyan},
    ['r?'] = {deep = palette.cyan,    light = palette.lightcyan},
    v      = {deep = palette.yellow,  light = palette.lightyellow},
    [''] = {deep = palette.yellow,  light = palette.lightyellow},
    V      = {deep = palette.yellow,  light = palette.lightyellow},
    s      = {deep = palette.magenta, light = palette.lightmagenta},
    S      = {deep = palette.magenta, light = palette.lightmagenta},
    [''] = {deep = palette.magenta, light = palette.lightmagenta},
    R      = {deep = palette.magenta, light = palette.lightmagenta},
    Rv     = {deep = palette.magenta, light = palette.lightmagenta},
    c      = {deep = palette.red,     light = palette.lightred},
    cv     = {deep = palette.red,     light = palette.lightred},
    ce     = {deep = palette.red,     light = palette.lightred},
    ['!']  = {deep = palette.red,     light = palette.lightred},
    t      = {deep = palette.red,     light = palette.lightred},
  }

  gls.left = {}

  -- show mode
  table.insert(gls.left, { ViMode = {
    provider  = modeProvider,
    separator = "\u{E0B0}\u{00A0}",
    highlight           = 'GalaxyDeep',
    separator_highlight = 'GalaxyDeepSep',
  }})

  -- show current dir
  table.insert(gls.left, {
    CWD = {
      provider  = cwdProvider,
      separator = "\u{00A0}\u{E0B1}\u{00A0}",
      highlight           = 'GalaxyLight',
      separator_highlight = 'GalaxyLightSep',
    }
  })

  -- show current file icon
  table.insert(gls.left, {
    FileIcon = {
      condition = bufferHasFile,
      provider = 'FileIcon',
      highlight = 'GalaxyLight',

      separator = " ",
      separator_highlight = 'GalaxyLightSep',
    },
  })

  -- show current file name
  table.insert(gls.left, {
    FileName = {
      provider = function ()
        local file = vim.fn.expand('%:.')
        if vim.fn.empty(file) == 1 then return '' end
        -- if string.len(file_readonly()) ~= 0 then
        --   return file .. file_readonly()
        -- end
        if vim.bo.modifiable then
          if vim.bo.modified then
            return file .. '   '
          end
        end
        return file .. ' '
      end,
      highlight = 'GalaxyLight',
    }
  })

  table.insert(gls.left, { LeftEdge = {
    provider = emptyProvider,
    highlight = 'GalaxyLight',
  }})

  gls.right = {}

  table.insert(gls.right, { RightEdge = {
    provider = emptyProvider,
    highlight = 'GalaxyLight',
  }})

  table.insert(gls.right, { DiagnosticHint  = {
    provider = 'DiagnosticHint',
    icon = '\u{F059}\u{00A0}',
    highlight           = { palette.blue, palette.black },
  }})

  table.insert(gls.right, { DiagnosticInfo  = {
    provider = 'DiagnosticInfo',
    icon = '\u{F05A}\u{00A0}',
    highlight           = { palette.blue, palette.black },
  }})

  table.insert(gls.right, { DiagnosticWarn  = {
    provider = 'DiagnosticWarn',
    icon = '\u{F06A}\u{00A0}',
    highlight           = { palette.yellow, palette.black },
  }})

  table.insert(gls.right, { DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '\u{F057}\u{00A0}',
    highlight           = { palette.red, palette.black },
  }})

  gls.short_line_left = {
    { ShortLeftEdge = {
      provider = emptyProvider,
      highlight = { palette.lightblack, palette.lightblack }
    }}
  }

  gls.short_line_right = {
    { ShortRightEdge = {
      provider = emptyProvider,
      highlight = { palette.lightblack, palette.lightblack }
    }}
  }

  vim.api.nvim_set_option('showmode', false)  -- galaxyline で表示するので、vim標準のモード表示は隠す

  vim.api.nvim_exec([[
    augroup my-galaxyline
      autocmd!
      autocmd DirChanged global lua require("galaxyline").load_galaxyline()
      autocmd User MyFernModeChanged lua require("galaxyline").load_galaxyline()
    augroup END
  ]],false)


  gl.load_galaxyline()
end

if vim.g.colors_name == 'momiji' then
  M.setup(vim.g.momiji_colors)
else
  M.setup(require('my-colors'))
  vim.cmd[[ autocmd ColorScheme momiji ++once lua require('my-galaxyline').setup(g:momiji_colors) ]]
end

return M
