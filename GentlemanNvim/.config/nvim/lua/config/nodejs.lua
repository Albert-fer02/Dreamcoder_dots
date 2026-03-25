-- Node.js configuration for Neovim
local M = {}

local function get_system_node()
  local paths = {
    "/usr/bin/node",
    "/usr/local/bin/node",
    "/opt/homebrew/bin/node",
    vim.fn.expand("~/.volta/bin/node"),
    vim.fn.expand("~/.nix-profile/bin/node"),
  }
  for _, path in ipairs(paths) do
    if vim.fn.executable(path) == 1 then return path end
  end
  return vim.fn.exepath("node")
end

function M.setup()
  local node = get_system_node()
  if node == "" then return end
  
  local ok, out = pcall(vim.fn.system, node .. " --version")
  if not ok then return end
  
  -- Strip ANSI codes and whitespace
  out = out:gsub("\27%[[%d;]*[a-zA-Z]", ""):gsub("%s+", "")
  local major = tonumber(out:match("(%d+)"))
  
  if major and major >= 18 then
    vim.g.node_host_prog = node
  end
end

return M
