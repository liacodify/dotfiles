-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.opt.wrap = true

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    if vim.bo.filetype ~= "snacks_picker" and vim.bo.filetype ~= "snacks_picker_list" then
      pcall(function()
        local explorers = Snacks.picker.get({ source = "explorer" })
        for _, picker in ipairs(explorers) do
          picker:close()
        end
      end)
    end
  end,
})
