local gl = require('galaxyline')
local gls = gl.section

local M = {
  mode_texts = {
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
  },
  mode_colors = {},
}

M.get_mode_color = function()
  -- モードに応じた色のセット {deep = ..., light = ...} を返す
  local mode_color = M.mode_colors[vim.fn.mode()]
  local file_type = vim.api.nvim_buf_get_option(0, 'filetype')
  if file_type == 'fern' then
    local fern_mode = vim.b.my_fern_mode
    if fern_mode == 'operate' then
      mode_color = {palette.magenta, palette.lightmagenta}
    end
  end
  return mode_color
end

M.setup = function(palette)
  M.mode_colors = {
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

  local function hi(component, fg, bg)
    -- 対象コンポーネントに色を付ける
    vim.cmd('hi Galaxy' .. component .. '    guifg=' .. fg ..' guibg=' .. bg)
  end

  local function hisep(component, fg, bg)
    -- 対象コンポーネントのセパレータに色を付ける
    vim.cmd('hi Galaxy' .. component .. 'Separator guifg=' .. fg ..' guibg=' .. bg)
  end

  -- 真ん中の領域をモードカラーで埋めるため、左右の一番真ん中よりに置くcomponent
  local edge = {
    provider = function() return '' end,
    highlight = 'GalaxyLight',
    separator_highlight = 'GalaxyLightSep'
  }

  gls.left[1] = {
    ViMode = {
      provider = function()
        local mode_color = M.get_mode_color()
        vim.cmd('hi GalaxyDeep     guifg=' .. palette.black   .. ' guibg=' .. mode_color.deep)
        vim.cmd('hi GalaxyDeepSep  guifg=' .. mode_color.deep .. ' guibg=' .. mode_color.light)
        vim.cmd('hi GalaxyLight    guifg=' .. palette.black   .. ' guibg=' .. mode_color.light)
        vim.cmd('hi GalaxyLightSep guifg=' .. palette.black   .. ' guibg=' .. mode_color.light)
        return "\u{00A0}" .. M.mode_texts[vim.fn.mode()]
      end,
      highlight = 'GalaxyDeep',

      separator = "\u{E0B0}\u{00A0}",
      separator_highlight = 'GalaxyDeepSep',
    },
  }

  gls.left[2] = {
    FileIcon = {
      condition = function()
        if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
          return true
        end
        return false
      end,
      provider = 'FileIcon',
      highlight = 'GalaxyLight',

      separator = "\u{00A0}\u{E0B1}\u{00A0}",
      separator_highlight = 'GalaxyLightSep',
    },
  }

  -- get current dir
  gls.left[3] = {
    CWD = {
      provider = function ()
        return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
      end,
      highlight = 'GalaxyLight',

      separator = "\u{00A0}\u{E0B1}\u{00A0}",
      separator_highlight = 'GalaxyLightSep',
    }
  }

  local provider_vcs = require('galaxyline.provider_vcs')

  -- get current branch
  gls.left[4] = {
    GitBranch = {
      condition = function()
        local current_dir = vim.fn.getcwd()
        local result = provider_vcs.get_git_dir(current_dir)
        if not result then
          return false
        end
        return true
      end,
      icon = '\u{E0A0} ',

      provider = 'GitBranch',
      highlight = 'GalaxyLight',

      separator = "\u{00A0}\u{E0B1}\u{00A0}",
      separator_highlight = 'GalaxyLightSep',
    }
  }

  -- get current file name
  gls.left[5] = {
    FileName = {
      provider = 'FileName',
      highlight = 'GalaxyLight',
    }
  }

  gls.left[5] = { LeftEdge = edge }

  gls.right[1] = { RightEdge = edge }

  local function with_prefix(prefix, value)
    if not value or value == 0 then
      return ''
    end
    return prefix .. ' ' .. value
  end

  gls.right[2] = {
    GitStat = {
      provider = function()
        if vim.bo.buftype == 'terminal' then
          return '' -- TODO: get title and parse it as path
        end

        local location = vim.fn.getcwd()
        local stat = require('my-gitstate').get_git_status(location)
        if stat == nil then
          return ''
        end

        local output = vim.fn.trim(vim.fn.join(vim.tbl_filter(function(w)
          return w ~= nil and w ~= ''
        end, {
          with_prefix("\u{FF55D}", stat.ahead),     -- 󿕝 .
          with_prefix("\u{FF545}", stat.behind),    -- 󿕅 .
          stat.sync,
          with_prefix('\u{FFBC2}', stat.unmerged),  -- 󿯂 .
          with_prefix("\u{FF62B}", stat.staged),    -- 󿘫 .
          with_prefix("\u{FF914}", stat.unstaged),  -- 󿤔 .
          with_prefix("\u{FF7D5}", stat.untracked), -- 󿟕 .
        })))
        if output == '' then
          return output
        else
          return ' ' .. output .. ' '
        end
      end,
      highlight = { palette.lightred, palette.black },

      separator = ' ',
      separator_highlight = 'GalaxyLightSep'
    }
  }

  gls.right[3] = { DiagnosticHint  = { provider = 'DiagnosticHint',  icon = '\u{F059}' } }
  gls.right[4] = { DiagnosticInfo  = { provider = 'DiagnosticInfo',  icon = '\u{F05A}' } }
  gls.right[5] = { DiagnosticWarn  = { provider = 'DiagnosticWarn',  icon = '\u{F06A}' } }
  gls.right[6] = { DiagnosticError = { provider = 'DiagnosticError', icon = '\u{F057}' } }

  vim.api.nvim_set_option('showmode', false)  -- galaxyline で表示するので、vim標準のモード表示は隠す

  vim.cmd[[ autocmd DirChanged global lua require("galaxyline").load_galaxyline()]]
  vim.cmd[[ autocmd User MyFernModeChanged lua require("galaxyline").load_galaxyline()]]

  gls.short_line_left = gls.left
  gls.short_line_right = gls.right

  gl.load_galaxyline()
end

if vim.g.colors_name == 'momiji' then
  M.setup(vim.g.momiji_colors)
else
  M.setup(require('my-colors'))
  vim.cmd[[ autocmd ColorScheme momiji ++once lua require('my-galaxyline').setup(g:momiji_colors) ]]
end

return M
