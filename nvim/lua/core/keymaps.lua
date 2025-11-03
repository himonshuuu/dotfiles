local keymap = vim.keymap.set

keymap("n", "<leader>w", ":w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })
keymap("n", "<leader>e", ":e .<CR>", { desc = "Open File Explorer"})

keymap("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlights" })
