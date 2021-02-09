local M = {}

M.get_git_status = function(path)
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

return M
