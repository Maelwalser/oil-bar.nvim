local M = {}

---
-- Default configuration for the sidebar
---
M.defaults = {
  default_file_explorer = true,
  columns = {
    "icon",
  },
  win_options = {
    wrap = false,
    signcolumn = "no",
    cursorcolumn = false,
    foldcolumn = "0",
    spell = false,
    list = false,
    conceallevel = 3,
    concealcursor = "nvic",
  },
}

---
-- custom <CR> action logic
---
function M.sidebar_cr_action()
  local oil = require("oil")
  local current_win = vim.api.nvim_get_current_win()
  -- Check if we are in the "sidebar" window
  local ok, is_sidebar = pcall(vim.api.nvim_win_get_var, current_win, 'oil_sidebar')

  local entry = oil.get_cursor_entry()
  if not entry then
    return
  end

  -- IF we are in the sidebar, use sidebar logic
  if ok and is_sidebar then
    if entry.type == "directory" then
      oil.select() -- Navigate *in* the sidebar
      return
    end

    -- It's a file, open it to the right
    local filepath = oil.get_current_dir() .. entry.name
    local sidebar_win_id = current_win

    vim.cmd('wincmd l') -- Move to window on the right
    local target_win_id = vim.api.nvim_get_current_win()

    -- If we are still in the sidebar
    if target_win_id == sidebar_win_id then
      vim.cmd('vsplit') -- Create a new window to the right
    end

    vim.cmd('edit ' .. vim.fn.fnameescape(filepath))
    vim.api.nvim_set_current_win(sidebar_win_id) -- Focus back on sidebar

  -- ELSE in a normal oil window use default behavior
  else
    oil.select() -- This is "actions.select"
  end
end

---
-- sidebar toggle 
---
function M.toggle()
  local sidebar_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local ok, is_sidebar = pcall(vim.api.nvim_win_get_var, win, 'oil_sidebar')
    if ok and is_sidebar then
      sidebar_win = win
      break
    end
  end

  if sidebar_win then
    local win_count = #vim.api.nvim_list_wins()
    if win_count > 1 then
      vim.api.nvim_win_close(sidebar_win, false)
    else
      -- If it's the last window, close oil and open an empty buffer
      pcall(vim.api.nvim_win_del_var, sidebar_win, 'oil_sidebar')
      vim.cmd("enew")
    end
    return
  end

  -- No sidebar found, create one
  local original_win = vim.api.nvim_get_current_win()
  vim.cmd("vsplit")
  vim.cmd("wincmd H") -- Move to the far left
  vim.cmd("vertical resize 30")

  local original_buf = vim.api.nvim_win_get_buf(original_win)
  local original_ft = vim.api.nvim_buf_get_option(original_buf, 'filetype')

  if original_ft == 'oil' then
    -- If we're already in oil, open the cwd
    require("oil").open(vim.fn.getcwd())
  else
    -- Otherwise, open oil 
    require("oil").open()
  end

  -- Tag the new window as our sidebar
  local new_sidebar_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_var(new_sidebar_win, 'oil_sidebar', true)

  -- Focus back on the original window if it wasn't oil
  if original_ft ~= 'oil' then
    vim.api.nvim_set_current_win(original_win)
  end
end

return M
