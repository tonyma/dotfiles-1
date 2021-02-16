return function (delay, fn)
  local lastTime = 0
  local lastResult = 0
  return function()
    local elapsed = vim.loop.now() - lastTime
    if elapsed > delay then
      lastResult = fn()
      lastTime = vim.loop.now()
    end
    return lastResult
  end
end
