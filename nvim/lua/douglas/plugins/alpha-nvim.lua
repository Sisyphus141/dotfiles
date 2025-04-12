return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        dashboard.section.header.val = {
            " __        __   _                            __  __        ____                      _ _             ",
            " \\ \\      / /__| | ___ ___  _ __ ___   ___  |  \\/  |_ __  / ___|  ___ _ ____   _____| | | ___  _ __  ",
            "  \\ \\ /\\ / / _ \\ |/ __/ _ \\| '_ ` _ \\ / _ \\ | |\\/| | '__| \\___ \\ / _ \\ '__\\ \\ / / _ \\ | |/ _ \\| '_ \\ ",
            "   \\ V  V /  __/ | (_| (_) | | | | | |  __/ | |  | | |     ___) |  __/ |   \\ V /  __/ | | (_) | | | |",
            "    \\_/\\_/ \\___|_|\\___\\___/|_| |_| |_|\\___| |_|  |_|_|    |____/ \\___|_|    \\_/ \\___|_|_|\\___/|_| |_|",
            "                                                                                                     ",
        }

        dashboard.section.buttons.val = {}

        alpha.setup(dashboard.opts)

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "alpha",
            callback = function()
                vim.keymap.set("n", "<CR>", "<cmd>Ex<CR>", { buffer = true, noremap = true, silent = true })
            end,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "alpha",
            callback = function()
                vim.opt_local.foldenable = false
            end,
        })
    end,
}

