local M = {}

---
-- The main setup function.
---
function M.setup(opts)
  local core = require("oil-bar.core")

  -- Handle user-defined plugin options
  opts = opts or {}
  
  -- Get the toggle keymap, defaulting to <leader>e
  local toggle_keymap = opts.keymap or "<leader>e"

  opts.keymap = nil

  -- Configure oil.nvim
  local oil_config = vim.tbl_deep_extend("force", {}, core.defaults, opts)

  -- Ensure keymaps table exists
  oil_config.keymaps = oil_config.keymaps or {}

  -- Force our special <CR> action
  oil_config.keymaps["<CR>"] = core.sidebar_cr_action

  -- Call the real oil.setup()
  require("oil").setup(oil_config)

  -- Set up this plugin's keymaps
  vim.keymap.set("n", toggle_keymap, M.toggle, { desc = "Toggle file explorer" })
end

---
-- The public toggle function.
---
function M.toggle()
  require("oil-bar.core").toggle()
end

return M
