return {
    "mbbill/undotree", -- UndoTree plugin
},
{
    "akinsho/bufferline.nvim", -- Bufferline plugin
    config = function()
        require("bufferline").setup {
            options = {
                numbers = "both",
                diagnostics = "nvim_lsp",
                separator_style = "slant",
                show_buffer_close_icons = false,
                show_close_icon = false,
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = "File Explorer",
                        text_align = "left",
                        padding = 1
                    }
                }
            }
        }
    end,
}

