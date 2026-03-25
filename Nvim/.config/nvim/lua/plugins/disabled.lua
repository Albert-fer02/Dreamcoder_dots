-- Dreamcoder Optimization: Disabling Bloat
-- We prefer Oil.nvim over Neo-tree and simple buffers over Bufferline.

return {
  -- We prefer Oil.nvim for file management
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  
  -- We prefer simple buffers or Snacks.picker
  { "akinsho/bufferline.nvim", enabled = false },
  
  -- Disable dashboard-nvim if we use Snacks.dashboard
  { "nvimdev/dashboard-nvim", enabled = false },
  
  -- Disable some UI elements that might be distracting
  { "rcarriga/nvim-notify", enabled = true }, -- Keep notifications but we might use Snacks.notifier
}
