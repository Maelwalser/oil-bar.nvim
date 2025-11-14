local M = {}

---
-- This is the custom <CR> action logic.
---
function M.sidebar_cr_action()
  local oil = require("oil")
  local current_win = vim.api.nvim_get_current_win()
  local ok, is_sidebar = pcall(vim.api.nvim_win_get_var, current_win, 'oil_sidebar')

  local entry = oil.get_cursor_entry()
  if not entry then
    return
  end

  if ok and is_sidebar then
    if entry.type == "directory" then
      oil.select() -- Navigate *in* the sidebar
      return
    end

    -- It's a file, open it to the right
    local filepath = oil.get_current_dir() .. entry.name
    local sidebar_win_id = current_win
    vim.cmd('wincmd l')
    local target_win_id = vim.api.nvim_get_current_win()
    if target_win_id == sidebar_win_id then
      vim.cmd('vsplit')
    end
    vim.cmd('edit ' .. vim.fn.fnameescape(filepath))
    vim.api.nvim_set_current_win(sidebar_win_id)
  else
    oil.select() -- This is "actions.select"
  end
end

---
-- The sidebar toggle logic.
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
      pcall(vim.api.nvim_win_del_var, sidebar_win, 'oil_sidebar')
      vim.cmd("enew")
    end
    return
  end

  local original_win = vim.api.nvim_get_current_win()
  vim.cmd("vsplit")
  vim.cmd("wincmd H")
  vim.cmd("vertical resize 30")
  local original_buf = vim.api.nvim_win_get_buf(original_win)
  local original_ft = vim.api.nvim_buf_get_option(original_buf, 'filetype')
  if original_ft == 'oil' then
    require("oil").open(vim.fn.getcwd())
  else
    require("oil").open()
  end
  local new_sidebar_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_var(new_sidebar_win, 'oil_sidebar', true)
  if original_ft ~= 'oil' then
    vim.api.nvim_set_current_win(original_win)
  end
end

return M
