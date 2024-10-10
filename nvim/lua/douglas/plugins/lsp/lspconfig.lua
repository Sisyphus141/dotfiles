return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        local opts = { noremap = true, silent = true }
        local keymap = vim.keymap.set

        local on_attach = function(client, bufnr)
            opts.buffer = bufnr

            keymap("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
            keymap("n", "gD", vim.lsp.buf.declaration, opts)
            keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
            keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
            keymap("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
            keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
            keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
            keymap("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
            keymap("n", "<leader>d", vim.diagnostic.open_float, opts)
            keymap("n", "[d", vim.diagnostic.goto_prev, opts)
            keymap("n", "]d", vim.diagnostic.goto_next, opts)
            keymap("n", "K", vim.lsp.buf.hover, opts)
            keymap("n", "<leader>rs", ":LspRestart<CR>", opts)
        end

        local capabilities = cmp_nvim_lsp.default_capabilities()

        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        -- clangd setup
        lspconfig.clangd.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "c", "cpp", "objc", "objcpp" },
            cmd = { "/usr/bin/clangd", "--background-index", "--suggest-missing-includes", "--clang-tidy" },
            settings = {
                clangd = {
                    fallbackFlags = {
                        "-std=c++17",
                        "-isystem/usr/include/c++/12",
                        "-isystem/usr/include/x86_64-linux-gnu/c++/12",
                        "-isystem/usr/include/c++/12/backward",
                        "-isystem/usr/lib/gcc/x86_64-linux-gnu/12/include",
                        "-isystem/usr/local/include",
                        "-isystem/usr/lib/gcc/x86_64-linux-gnu/12/include-fixed",
                        "-isystem/usr/include/x86_64-linux-gnu",
                        "-isystem/usr/include",
                    },
                },
            },
        })

        -- Disable tsserver
        lspconfig.tsserver.setup({
            capabilities = capabilities,
            on_attach = function() end, -- Disable tsserver by doing nothing in on_attach
            filetypes = {}, -- Disable filetypes to prevent tsserver from attaching
        })

        -- vtsls setup
        lspconfig.vtsls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = {
                "javascript",
                "javascriptreact",
                "javascript.jsx",
                "typescript",
                "typescriptreact",
                "typescript.tsx",
            },
            settings = {
                complete_function_calls = true,
                vtsls = {
                    enableMoveToFileCodeAction = true,
                    autoUseWorkspaceTsdk = true,
                    experimental = {
                        completion = {
                            enableServerSideFuzzyMatch = true,
                        },
                    },
                },
                typescript = {
                    updateImportsOnFileMove = { enabled = "always" },
                    suggest = {
                        completeFunctionCalls = true,
                    },
                    inlayHints = {
                        enumMemberValues = { enabled = true },
                        functionLikeReturnTypes = { enabled = true },
                        parameterNames = { enabled = "literals" },
                        parameterTypes = { enabled = true },
                        propertyDeclarationTypes = { enabled = true },
                        variableTypes = { enabled = false },
                    },
                },
            },
            keys = {
                {
                    "gD",
                    function()
                        local params = vim.lsp.util.make_position_params()
                        vim.lsp.buf.execute_command({
                            command = "typescript.goToSourceDefinition",
                            arguments = { params.textDocument.uri, params.position },
                        })
                    end,
                    desc = "Goto Source Definition",
                },
                {
                    "gR",
                    function()
                        vim.lsp.buf.execute_command({
                            command = "typescript.findAllFileReferences",
                            arguments = { vim.uri_from_bufnr(0) },
                        })
                    end,
                    desc = "File References",
                },
                {
                    "<leader>co",
                    vim.lsp.buf.execute_command({ command = "source.organizeImports" }),
                    desc = "Organize Imports",
                },
                {
                    "<leader>cM",
                    vim.lsp.buf.execute_command({ command = "source.addMissingImports.ts" }),
                    desc = "Add missing imports",
                },
                {
                    "<leader>cu",
                    vim.lsp.buf.execute_command({ command = "source.removeUnused.ts" }),
                    desc = "Remove unused imports",
                },
                {
                    "<leader>cD",
                    vim.lsp.buf.execute_command({ command = "source.fixAll.ts" }),
                    desc = "Fix all diagnostics",
                },
                {
                    "<leader>cV",
                    function()
                        vim.lsp.buf.execute_command({ command = "typescript.selectTypeScriptVersion" })
                    end,
                    desc = "Select TS workspace version",
                },
            },
        })

        -- eslint_d setup
        lspconfig.eslint.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = { "eslint_d", "--stdio" },
            filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
            settings = {
                validate = "on",
            },
        })

        -- Ensure diagnostics are configured to use eslint_d
        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = true,
                signs = true,
                update_in_insert = false,
            }
        )
    end,
}

