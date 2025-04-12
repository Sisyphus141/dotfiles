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

        local keymap = vim.keymap.set
        local capabilities = cmp_nvim_lsp.default_capabilities()

        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        vim.diagnostic.config({
            virtual_text = true,
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = signs.Error,
                    [vim.diagnostic.severity.WARN]  = signs.Warn,
                    [vim.diagnostic.severity.HINT]  = signs.Hint,
                    [vim.diagnostic.severity.INFO]  = signs.Info,
                },
            },
            update_in_insert = false,
        })

        local on_attach = function(client, bufnr)
            local opts = { noremap = true, silent = true, buffer = bufnr }

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
            keymap("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)

            if client:supports_method("textDocument/formatting") then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ async = false })
                    end,
                })
            end
        end

        local function get_ts_client()
            for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
                if client.name == "vtsls" then
                    return client
                end
            end
        end

        local function exec_ts_command(command, args)
            local client = get_ts_client()
            if client then
                client.request("workspace/executeCommand", {
                    command = command,
                    arguments = args or {},
                }, nil, 0)
            end
        end

        lspconfig.clangd.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "c", "cpp", "objc", "objcpp" },
            cmd = {
                "/usr/bin/clangd",
                "--background-index",
                "--suggest-missing-includes",
                "--clang-tidy"
            },
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

        lspconfig.vtsls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = {
                "javascript", "javascriptreact", "javascript.jsx",
                "typescript", "typescriptreact", "typescript.tsx",
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
                    suggest = { completeFunctionCalls = true },
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
                        exec_ts_command("typescript.goToSourceDefinition", { params.textDocument.uri, params.position })
                    end,
                    desc = "Goto Source Definition",
                },
                {
                    "gR",
                    function()
                        exec_ts_command("typescript.findAllFileReferences", { vim.uri_from_bufnr(0) })
                    end,
                    desc = "File References",
                },
                { "<leader>co", function() exec_ts_command("source.organizeImports") end, desc = "Organize Imports" },
                { "<leader>cM", function() exec_ts_command("source.addMissingImports.ts") end, desc = "Add missing imports" },
                { "<leader>cu", function() exec_ts_command("source.removeUnused.ts") end, desc = "Remove unused imports" },
                { "<leader>cD", function() exec_ts_command("source.fixAll.ts") end, desc = "Fix all diagnostics" },
                { "<leader>cV", function() exec_ts_command("typescript.selectTypeScriptVersion") end, desc = "Select TS workspace version" },
            },
        })

        lspconfig.eslint.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = { "eslint_d", "--stdio" },
            filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
            settings = { validate = "on" },
        })
    end,
}

