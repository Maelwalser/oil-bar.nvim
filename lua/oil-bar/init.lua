local M = {}

function M.setup(opts)
  local core = require("oil-bar.core")

  -- Handle user-defined plugin options
  opts = opts or {}
  
  -- Get the toggle keymap, defaulting to <leader>e
  local toggle_keymap = opts.keymap or "<leader>e"

  -- Set the global toggle keymap
  vim.keymap.set("n", toggle_keymap, core.toggle, { desc = "Toggle file explorer" })

  -- Create an autocommand to apply the "smart" <CR> keymap
  local augroup = vim.api.nvim_create_augroup("OilBarSetup", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "oil",
    group = augroup,
    callback = function(args)
      -- This keymap overrides oil's default <CR>
      vim.keymap.set("n", "<CR>", core.sidebar_cr_action, {
        buffer = args.buf,
        desc = "Open file or folder (sidebar aware)",
      })
    end,
  })
end

return M
