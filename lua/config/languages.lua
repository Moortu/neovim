-- ================================================================================================
-- CENTRALIZED LANGUAGE TOOLING CONFIGURATION
-- All LSP servers, formatters, and linters are defined here
-- ================================================================================================

local M = {}

-- Language configurations
-- Each language can specify:
--   lsp: LSP server name(s)
--   formatter: formatter tool(s) for conform.nvim
--   linter: linter tool(s) for nvim-lint
--   lsp_config: custom LSP configuration
M.languages = {
	lua = {
		lsp = "lua_ls",
		formatter = "stylua",
		linter = "luacheck",
		lsp_config = function(lspconfig, capabilities, on_attach)
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
					},
				},
			})
		end,
	},

	c = {
		lsp = "clangd",
		formatter = "clang-format",
		linter = "cpplint", -- Mason-supported; nvim-lint supports cpplint
		lsp_config = function(lspconfig, capabilities, on_attach)
			lspconfig.clangd.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
				},
			})
		end,
	},

	cpp = {
		lsp = "clangd",
		formatter = "clang-format",
		linter = "cpplint",
		-- Shares clangd config with C
	},

	java = {
		lsp = "jdtls",
		formatter = "google-java-format",
		linter = "checkstyle",
		-- Note: jdtls requires special setup, handled by nvim-jdtls plugin
	},

	kotlin = {
		lsp = "kotlin_language_server",
		formatter = "ktlint",
		linter = "ktlint", -- ktlint does both formatting and linting
	},

	zig = {
		lsp = "zls",
		-- zls has built-in formatting and diagnostics
		-- lsp_config = function(lspconfig, capabilities, on_attach)
		-- 	lspconfig.zls.setup({
		-- 		capabilities = capabilities,
		-- 		on_attach = on_attach,
		-- 		root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
		-- 		settings = {
		-- 			zls = {
		-- 				enable_inlay_hints = true,
		-- 				enable_snippets = true,
		-- 				warn_style = true,
		-- 			},
		-- 		},
		-- 	})
		-- end,
	},

	javascript = {
		lsp = "ts_ls",
		formatter = "prettier",
		linter = "eslint_d",
	},

	typescript = {
		lsp = "ts_ls",
		formatter = "prettier",
		linter = "eslint_d",
	},

	javascriptreact = {
		lsp = "ts_ls",
		formatter = "prettier",
		linter = "eslint_d",
	},

	typescriptreact = {
		lsp = "ts_ls",
		formatter = "prettier",
		linter = "eslint_d",
	},

	json = {
		lsp = "ts_ls",
		formatter = "prettier",
		linter = "jsonlint",
	},

	html = {
		formatter = "prettier",
		linter = "htmlhint",
	},

	css = {
		formatter = "prettier",
		linter = "stylelint",
	},

	markdown = {
		linter = "markdownlint",
		formatter = "prettier",
	},
}

-- Get list of all LSP servers to install
function M.get_lsp_servers()
	local servers = {}
	local seen = {}
	for _, config in pairs(M.languages) do
		if config.lsp and not seen[config.lsp] then
			table.insert(servers, config.lsp)
			seen[config.lsp] = true
		end
	end
	return servers
end

-- Get list of all formatters to install
function M.get_formatters()
	local formatters = {}
	local seen = {}
	for _, config in pairs(M.languages) do
		if config.formatter and not seen[config.formatter] then
			table.insert(formatters, config.formatter)
			seen[config.formatter] = true
		end
	end
	return formatters
end

-- Get list of all linters to install
function M.get_linters()
	local linters = {}
	local seen = {}
	for _, config in pairs(M.languages) do
		if config.linter and not seen[config.linter] then
			table.insert(linters, config.linter)
			seen[config.linter] = true
		end
	end
	return linters
end

-- Get formatters_by_ft table for conform.nvim
function M.get_formatters_by_ft()
	local formatters_by_ft = {}
	for ft, config in pairs(M.languages) do
		if config.formatter then
			formatters_by_ft[ft] = { config.formatter }
		end
	end
	return formatters_by_ft
end

-- Get linters_by_ft table for nvim-lint
function M.get_linters_by_ft()
	local linters_by_ft = {}
	for ft, config in pairs(M.languages) do
		if config.linter then
			linters_by_ft[ft] = { config.linter }
		end
	end
	return linters_by_ft
end

-- Setup LSP handlers
function M.setup_lsp_handlers(lspconfig, capabilities, on_attach)
	local handlers = {
		-- Default handler
		function(server_name)
			lspconfig[server_name].setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
		end,
	}

	-- Add custom configs
	for _, config in pairs(M.languages) do
		if config.lsp and config.lsp_config then
			handlers[config.lsp] = function()
				config.lsp_config(lspconfig, capabilities, on_attach)
			end
		end
	end

	return handlers
end

-- Conform formatter configurations (tool-specific settings)
M.formatter_configs = {
	["clang-format"] = {
		prepend_args = { "-style=file", "-fallback-style=LLVM" },
	},
}

-- Format-on-save exclusions
M.format_on_save_exclude = {
	-- Add filetypes here if you don't want auto-formatting
	-- c = true,
	-- cpp = true,
}

return M
