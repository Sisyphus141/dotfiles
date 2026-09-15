return {
	"neovim/nvim-lspconfig",

	event = { "BufReadPre", "BufNewFile" },

	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},

	config = function()
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local capabilities = cmp_nvim_lsp.default_capabilities()

		local keymap = vim.keymap.set

		-- =========================
		-- Diagnostics
		-- =========================

		local signs = {
			Error = " ",
			Warn = " ",
			Hint = "󰠠 ",
			Info = " ",
		}

		vim.diagnostic.config({
			virtual_text = true,

			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = signs.Error,
					[vim.diagnostic.severity.WARN] = signs.Warn,
					[vim.diagnostic.severity.HINT] = signs.Hint,
					[vim.diagnostic.severity.INFO] = signs.Info,
				},
			},

			update_in_insert = false,
		})

		-- =========================
		-- on_attach
		-- =========================

		local on_attach = function(client, bufnr)
			local opts = {
				noremap = true,
				silent = true,
				buffer = bufnr,
			}

			keymap("n", "gR", vim.lsp.buf.references, opts)
			keymap("n", "gD", vim.lsp.buf.declaration, opts)
			keymap("n", "gd", vim.lsp.buf.definition, opts)
			keymap("n", "gi", vim.lsp.buf.implementation, opts)
			keymap("n", "gt", vim.lsp.buf.type_definition, opts)

			keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
			keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)

			keymap("n", "<leader>d", vim.diagnostic.open_float, opts)

			keymap("n", "[d", vim.diagnostic.goto_prev, opts)
			keymap("n", "]d", vim.diagnostic.goto_next, opts)

			keymap("n", "K", vim.lsp.buf.hover, opts)

			keymap("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)

			keymap("n", "<leader>f", function()
				vim.lsp.buf.format({ async = true })
			end, opts)

			if client:supports_method("textDocument/formatting") then
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,

					callback = function()
						vim.lsp.buf.format({ async = false })
					end,
				})
			end
		end

		-- =========================
		-- CLANGD
		-- =========================

		vim.lsp.config("clangd", {
			capabilities = capabilities,

			on_attach = on_attach,

			cmd = {
				"/opt/homebrew/opt/llvm/bin/clangd",
				"--background-index",
				"--clang-tidy",
			},

			filetypes = {
				"c",
				"cpp",
				"objc",
				"objcpp",
			},
		})

		vim.lsp.enable("clangd")

		-- =========================
		-- VTSLS
		-- =========================

		vim.lsp.config("vtsls", {
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
		})

		vim.lsp.enable("vtsls")

		-- =========================
		-- ESLINT
		-- =========================

		vim.lsp.config("eslint", {
			capabilities = capabilities,

			on_attach = on_attach,

			cmd = {
				"eslint_d",
				"--stdio",
			},

			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			},
		})

		vim.lsp.enable("eslint")

		-- =========================
		-- RACKET
		-- =========================

		vim.lsp.config("racket_langserver", {
			capabilities = capabilities,

			on_attach = on_attach,

			cmd = {
				"racket",
				"--lib",
				"racket-langserver",
			},

			filetypes = {
				"racket",
				"scheme",
			},

			root_markers = {
				".git",
			},
		})

		vim.lsp.enable("racket_langserver")
	end,
}
