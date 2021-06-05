local M = {
  map = vim.tbl_map,
  filter = vim.tbl_filter,
  assign = vim.fn.extend,
  join = vim.fn.join,
  empty = vim.empty_dict
}

M.fold = function(fn, list, init)
  local memo = init
  for _, v in ipairs(list) do
    memo = fn(memo, v)
  end
  return memo
end

return M
