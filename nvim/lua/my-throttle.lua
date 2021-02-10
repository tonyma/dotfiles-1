return function (delay, fn)
  local timer = nil
  local lastTime = 0
  local lastResult = 0
  return function()
    local elapsed = vim.loop.now() - lastTime
    local execute = function()
      lastResult = fn()
      lastTime = vim.loop.now()
      return lastResult
    end
    if not timer then
      return execute()
    end
    if timer then
      timer:close()
      timer = nil
    end
    if elapsed > delay then
      return execute() 
    else
      timer = vim.defer_fn(execute, delay)
      return lastResult
    end
  end
end
