vim.pack.add({
    "https://github.com/bassamsdata/namu.nvim",
})

vim.keymap.set("n", "<leader>ss", ":Namu symbols<cr>", {
    desc = "Jump to LSP symbol",
    silent = true,
})

vim.keymap.set("n", "<leader>sw", ":Namu workspace<cr>", {
    desc = "LSP Symbols - Workspace",
    silent = true,
})
