local lspinstall = require('lspinstall')

local M = {};
M.update = function()
  for _, server in pairs(lspinstall.installed_servers()) do
    lspinstall.install_server(server)
  end
end

return M
