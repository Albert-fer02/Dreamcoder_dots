-- Node.js configuration for Neovim (Powered by Dreamcoder Logic)
-- This ensures Neovim uses the SYSTEM Node.js, not project-specific versions
local M = {}

local function get_system_node()
  local system_paths = {
    "/opt/homebrew/bin/node",
    "/usr/local/bin/node",
    vim.fn.expand("~/.volta/bin/node"),
    vim.fn.expand("~/.nvm/versions/node/*/bin/node"),
    vim.fn.expand("~/.nix-profile/bin/node"),
    "/usr/bin/node",
  }

  for _, path in ipairs(system_paths) do
    if path:match("%*") then
      local expanded = vim.fn.glob(path, false, true)
      if #expanded > 0 then
        table.sort(expanded, function(a, b) return a > b end)
        path = expanded[1]
      else
        goto continue
      end
    end
    if vim.fn.executable(path) == 1 then return path end
    ::continue::
  end
  return vim.fn.exepath("node")
end

local function setup_nodejs()
  local node_path = get_system_node()
  if node_path ~= "" then
    local version_output = vim.fn.system(node_path .. " --version 2>/dev/null")
    if vim.v.shell_error == 0 then
      local version = version_output:gsub("\n", ""):gsub("v", "")
      local major = tonumber(version:match("^(%d+)"))
      
      if major and major >= 18 then
        vim.g.node_host_prog = node_path
        local npm_path = vim.fn.exepath("npm")
        if npm_path ~= "" then vim.g.npm_host_prog = npm_path end
        return true
      else
        vim.notify("⚠️  Node.js v" .. version .. " is too old for Neovim plugins (v18+ required).", vim.log.levels.WARN)
        return false
      end
    end
  end
  return false
end

function M.setup(opts)
  setup_nodejs()
end

return M
