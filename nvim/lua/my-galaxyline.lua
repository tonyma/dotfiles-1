local M = {}
M.setupGalaxyline = function()
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
        -- local file_type = vim.api.nvim_buf_get_option(0, 'filetype')
        local file_type = vim.api.nvim_buf_get_option(0, 'filetype')
        if file_type == 'fern' then
          local fern_mode = vim.b['my_fern_mode']
          if fern_mode == 'operate' then
            mode_color = {momiji_colors.red, momiji_colors.bright_red}
          end
        end

        for _, side in ipairs({gls.left, gls.right}) do
          for index, components in pairs(side) do
            if index == 1 then
              for key in pairs(components) do
                vim.api.nvim_command('hi Galaxy' .. key .. '    guifg=' .. momiji_colors.black ..' guibg=' .. mode_color[1])
                vim.api.nvim_command('hi ' .. key .. 'Separator guifg=' .. mode_color[1]       ..' guibg=' .. mode_color[2])
              end
            else
              for key, component in pairs(components) do
                if component.highlight == nil then
                  vim.api.nvim_command('hi Galaxy' .. key .. '    guifg=' .. momiji_colors.black ..' guibg=' .. mode_color[2])
                else
                  vim.api.nvim_command('hi Galaxy' .. key .. '    guifg=' .. component.highlight[1] ..  ' guibg=' .. component.highlight[2])
                end
                vim.api.nvim_command('hi ' .. key .. 'Separator guifg=' .. momiji_colors.black ..' guibg=' .. mode_color[2])
              end
            end
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

  gls.left[5] = {
    DiffAdd      = {
      provider = 'DiffAdd',
      icon = '   ',
      highlight = { momiji_colors.blue, momiji_colors.grayscale1 },
    }
  }
  gls.left[6] = {
    DiffModified = {
      provider = 'DiffModified',
      icon = '   ',
      highlight = { momiji_colors.yellow, momiji_colors.grayscale1 },
    }
  }
  gls.left[7] = {
    DiffRemove   = {
      provider = 'DiffRemove',
      icon = '   ',
      highlight = { momiji_colors.red, momiji_colors.grayscale1 },
    }
  }
  gls.left[8] = { LeftEdge  = { provider = function() return '' end } }

  gls.right[1] = { RightEdge  = { provider = function() return '' end } }

  gls.right[3] = { DiagnosticHint  = { provider = 'DiagnosticHint',  icon = '\u{F059}' } }
  gls.right[4] = { DiagnosticInfo  = { provider = 'DiagnosticInfo',  icon = '\u{F05A}' } }
  gls.right[5] = { DiagnosticWarn  = { provider = 'DiagnosticWarn',  icon = '\u{F06A}' } }
  gls.right[6] = { DiagnosticError = { provider = 'DiagnosticError', icon = '\u{F057}' } }

  gls.right[7] = {
    GitBranch    = {
      provider = 'GitBranch',
      icon = '  \u{E0A0} '
    }
  }

  local function with_prefix(prefix, value)
    if not value or value == 0 then
      return ''
    end
    return prefix .. ' ' .. value
  end

  local function get_git_status(path)
    -- TODO: see
    -- https://git-scm.com/docs/git-status#_porcelain_format_version_2 and
    -- use porcelain v2
    local res = vim.fn.system("git -C '" .. path .. "' status --porcelain --branch --ahead-behind --untracked-files --renames")
    if string.sub(res, 1, 7) == 'fatal: ' then
      return nil
    end
    local info = { ahead = 0, behind = 0, sync = '', unmerged = 0, untracked = 0, staged = 0, unstaged = 0 }
    local file
    for _, file in next, vim.fn.split(res, "\n") do
      local staged = string.sub(file, 1, 1)
      local unstaged = string.sub(file, 2, 2)
      local changed = string.sub(file, 1, 2)
      if changed == '##' then
        -- ブランチ名を取得する
        local words = vim.fn.split(file, '\\.\\.\\.\\|[ \\[\\],]')
        if #words == 2 then
          info.local_branch = words[2] .. '?'
          info.sync = "\u{F12A}"
        else
          info.local_branch = words[2]
          info.remote_branch = words[3]
          if #words > 3 then
            local key = ''
            local i = ''
            local r = ''
            for i, r in ipairs(words) do
              if i > 3 then
                if key ~= '' then
                  info[key] = r
                  key = ''
                else
                  key = r
                end
              end
            end
          end
        end
      elseif staged == 'U' or unstaged == 'U' or changed == 'AA' or changed == 'DD' then
        info.unmerged = info.unmerged + 1
      elseif changed == '??'  then
        info.untracked = info.untracked + 1
      else
        if staged ~= ' ' then
          info.staged = info.staged + 1
        end
        if unstaged ~= ' ' then
          info.unstaged = info.unstaged + 1
        end
      end
    end
    return info
  end

  gls.right[2] = {
    GitStat = {
      provider = function()
        if vim.bo.buftype == 'terminal' then
          return '' -- TODO: get title and parse it as path
        end

        local location = vim.fn.getcwd()
        local stat = get_git_status(location)
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
      highlight = { momiji_colors.yellow, momiji_colors.grayscale1 },
      separator = ' ',
    }
  }

  vim.api.nvim_set_option('showmode', false)  -- galaxyline で表示するので、vim標準のモード表示は隠す

  vim.cmd[[
    autocmd User MyFernModeChanged lua require("galaxyline").load_galaxyline()
  ]]

  gl.load_galaxyline()
end

if vim.g.momiji_loaded then
  M.setupGalaxyline()
else
  vim.cmd[[autocmd User MomijiLoaded lua require('my-galaxyline').setupGalaxyline()]]
end

return M
