local gl = require('galaxyline')
local provider_vcs = require('galaxyline.provider_vcs')
local gls = gl.section

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
      modeColor = {palette.magenta, palette.lightmagenta}
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

-- 現在のディレクトリのGit Branchを取得するProvider
function gitBranchProvider()
  local cwd = vim.fn.getcwd()
  local gitDir = provider_vcs.get_git_dir(cwd)
  if not gitDir then return end

  -- If git directory not found then we're probably outside of repo or
  -- something went wrong. The same is when headFile is nil
  local headFile = io.open(gitDir..'/HEAD')
  if not headFile then return end

  local HEAD = headFile:read()
  headFile:close()

  -- If HEAD matches branch expression, then we're on named branch
  -- otherwise it is a detached commit
  local branchName = HEAD:match('ref: refs/heads/(.+)')
  if branchName == nil then return  end

  return branchName .. ' '
end
--
-- バッファがファイルを開いているかどうか
local function bufferHasFile()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end
  return false
end

-- 現在のディレクトリのGit Statusを取得するProvider
local function gitStatProvider()
  if vim.bo.buftype == 'terminal' then
    return '' -- TODO: get title and parse it as path
  end

  local location = vim.fn.getcwd()
  local stat = require('my-gitstate').get_git_status(location)
  if stat == nil then
    return ''
  end

  local function withPrefix(prefix, value)
    if not value or value == 0 then
      return ''
    end
    return prefix .. ' ' .. value
  end

  local output = vim.fn.trim(vim.fn.join(vim.tbl_filter(function(w)
    return w ~= nil and w ~= ''
  end, {
    withPrefix("\u{FF55D}", stat.ahead),     -- 󿕝 .
    withPrefix("\u{FF545}", stat.behind),    -- 󿕅 .
    stat.sync,
    withPrefix('\u{FFBC2}', stat.unmerged),  -- 󿯂 .
    withPrefix("\u{FF62B}", stat.staged),    -- 󿘫 .
    withPrefix("\u{FF914}", stat.unstaged),  -- 󿤔 .
    withPrefix("\u{FF7D5}", stat.untracked), -- 󿟕 .
  })))
  if output == '' then
    return output
  else
    return ' ' .. output .. ' '
  end
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

  -- show current branch
  table.insert(gls.left, {
    GitBranch = {
      condition = isinGitDir,
      icon = '\u{E0A0} ',
      provider  = gitBranchProvider,
      separator = "\u{E0B1}\u{00A0}",
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
      provider = 'FileName',
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

  -- show git stat
  table.insert(gls.right, { GitStat = {
    provider  = gitStatProvider,
    separator = ' ',
    highlight           = { palette.lightred, palette.black },
    separator_highlight = 'GalaxyLightSep'
  }})

  table.insert(gls.right, { DiagnosticHint  = {
    provider = 'DiagnosticHint',
    icon = '\u{F059}\u{00A0}',
    highlight           = { palette.lightred, palette.black },
  }})

  table.insert(gls.right, { DiagnosticInfo  = {
    provider = 'DiagnosticInfo',
    icon = '\u{F05A}\u{00A0}',
    highlight           = { palette.lightred, palette.black },
  }})

  table.insert(gls.right, { DiagnosticWarn  = {
    provider = 'DiagnosticWarn',
    icon = '\u{F06A}\u{00A0}',
    highlight           = { palette.lightred, palette.black },
  }})

  table.insert(gls.right, { DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '\u{F057}\u{00A0}',
    highlight           = { palette.lightred, palette.black },
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
    }},
    { RightGitStat = {
      provider  = gitStatProvider,
      separator = ' ',
      highlight           = { palette.lightred, palette.black },
      separator_highlight = 'GalaxyLightSep'
    }}
  }

  vim.api.nvim_set_option('showmode', false)  -- galaxyline で表示するので、vim標準のモード表示は隠す

  vim.cmd[[ autocmd DirChanged global lua require("galaxyline").load_galaxyline()]]
  vim.cmd[[ autocmd User MyFernModeChanged lua require("galaxyline").load_galaxyline()]]

  gl.load_galaxyline()
end

if vim.g.colors_name == 'momiji' then
  M.setup(vim.g.momiji_colors)
else
  M.setup(require('my-colors'))
  vim.cmd[[ autocmd ColorScheme momiji ++once lua require('my-galaxyline').setup(g:momiji_colors) ]]
end

return M
