-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<C-k>", 'a[]()<Left><Left><Left>', { desc = "Insert markdown link" })
vim.keymap.set("v", "<C-k>", 'c[<C-r>"]()<Esc>hi', { desc = "Wrap in markdown link" })
