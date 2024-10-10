return {
    "mbbill/undotree", -- Plugin repository
    config = function()
        -- Toggle undotree panel
        vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", { noremap = true, silent = true })

        -- Setup for persistent undo
        if vim.fn.has("persistent_undo") == 1 then
            local target_path = vim.fn.expand("~/.undodir")
            if vim.fn.isdirectory(target_path) == 0 then
                vim.fn.mkdir(target_path, "p", 0700)
            end
            vim.o.undodir = target_path
            vim.o.undofile = true
        end
    end,
}

