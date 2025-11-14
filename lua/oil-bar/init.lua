local M = {}

---
-- @param user_config table | nil: The user's custom config for oil.nvim
---
function M.setup(user_config)
  local core = require("oil-sidebar.core")

  -- Merge the user's config on top
  local config = vim.tbl_deep_extend("force", {}, core.defaults, user_config or {})

  config.keymaps = config.keymaps or {}

  --  *Force* custom <CR> keymap from core.
  config.keymaps["<CR>"] = core.sidebar_cr_action

  -- call the real oil.setup with the merged config
  require("oil").setup(config)
end

---
-- The public toggle function.
---
function M.toggle()
  require("oil-sidebar.core").toggle()
end

return M
