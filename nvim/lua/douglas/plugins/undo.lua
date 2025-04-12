return {
    "mbbill/undotree",
    config = function()
        -- Toggle Undotree panel
        vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", { noremap = true, silent = true })

        -- Setup for persistent undo
        if vim.fn.has("persistent_undo") == 1 then
            local target_path = vim.fn.expand(vim.fn.stdpath("data") .. "/undodir")
            if vim.fn.isdirectory(target_path) == 0 then
                vim.fn.mkdir(target_path, "p", 0700)
            end
            vim.opt.undodir = target_path
            vim.opt.undofile = true
        end
    end,
}

