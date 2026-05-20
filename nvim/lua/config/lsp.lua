local capabilities = vim.lsp.protocol.make_client_capabilities()

vim.lsp.config("bashls", {
	cmd = { "bash-language-server", "start" }, -- 启动命令
	filetypes = { "sh", "bash" }, -- 作用于哪些文件类型
	root_markers = { ".git", "package.json" }, -- 根目录标记（可选）
	settings = {}, -- 服务器特定设置
})

vim.lsp.config("perlnavigator", {
	capabilities = capabilities,
	init_options = {
		documentFeatures = {
			"documentSymbol", -- 必须启用
			"folding",
			"syntax",
		},
	},
	settings = {
		perlnavigator = {
			-- Windows 下 perl 通常在 PATH 中，不需要硬编码 /usr/bin/perl
			-- 如果报错找不到 perl，可以改为 "perl" 让系统自己去 PATH 找
			perlPath = vim.fn.has("win32") == 1 and "perl" or "/usr/bin/perl",
			enableWarnings = false,
			perlcriticEnabled = true,
			includePaths = {
				"lib",
				"t",
				-- 【修复核心】安全地获取用户主目录
				(function()
					local home = os.getenv("HOME") or os.getenv("USERPROFILE")
					if not home then
						return ""
					end -- 防止 nil
					-- Windows 路径分隔符处理
					local sep = vim.fn.has("win32") == 1 and "\\" or "/"
					return home .. sep .. "perl5" .. sep .. "lib" .. sep .. "perl5"
				end)(),
			},
		},
	},
})

vim.lsp.config("basedpyright", {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = { ".git", ".venv", "pyproject.toml", "pyrightconfig.json" },
	capabilities = capabilities,
	settings = {
		python = {
			pythonPath = (function()
				local venv_path = os.getenv("VIRTUAL_ENV")
				if venv_path and venv_path ~= "" then
					return venv_path .. (vim.fn.has("win32") == 1 and "\\Scripts\\python.exe" or "/bin/python")
				else
					return vim.fn.exepath("python3") or "python3" -- 系统 Python
				end
			end)(),
			analysis = {
				-- 类型检查模式，可选 "off", "basic", "strict"
				typeCheckingMode = "basic",
				-- 开启自动导入补全和建议的关键！
				autoImportCompletions = true,
				-- 诊断模式，设置为 "workspace" 以获得全局诊断，或 "openFilesOnly"
				diagnosticMode = "workspace",
				-- 启用未定义变量诊断（这是自动导入的前提）
				diagnosticSeverity = {
					reportUndefinedVariable = "error",
				},
				-- 如果你希望禁用基于 pyright 的 import 组织（交给 ruff），可以保留
				disableOrganizeImports = true,
				-- 删除无效的 extraPaths，或者改用 Windows 路径（一般不需要）
				-- extraPaths = {},

				reportMissingTypeStubs = "none",
				reportUnknownVariableType = "none",
				reportUnknownMemberType = "none",
				reportFunctionMemberAccess = "none",
				reportAny = false,
			},
		},
	},
})

-- 配置 Ruff 内置语言服务器（负责 linting 和 formatting）
vim.lsp.config("ruff", {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { ".git", "", "pyproject.toml", "pyrightconfig.json", "ruff.toml", ".ruff.toml" },
	capabilities = capabilities,
	-- 可选：覆盖某些能力，避免与 pyright 重复
	on_attach = function(client, bufnr)
		-- 禁用 hover 能力，让 pyright 提供更好的类型信息
		client.server_capabilities.hoverProvider = false
		-- 可选：保存时自动格式化
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ bufnr = bufnr, async = false })
			end,
		})
	end,
	init_options = {
		settings = {
			-- 你可以在这里配置 ruff 的具体行为，也可以在项目根目录的 ruff.toml 或 pyproject.toml 中配置
			lint = {
				ignore = { "F821" },
			},
		},
	},
})

vim.lsp.config("ts_ls", {
	filetypes = { "typescript", "javascript" },
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim).
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global.
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files.
				library = {
					-- 1. 添加 Vim 运行时路径
					vim.api.nvim_get_runtime_file("", true),
					-- 2. 添加 $VIMRUNTIME/lua 目录
					vim.fn.expand("$VIMRUNTIME/lua"),
				},
			},
			-- Do not send telemetry data containing a randomized but unique identifier.
			telemetry = {
				enable = false,
			},
		},
	},
})

vim.lsp.config("clangd", {
	capabilities = capabilities,
})

vim.lsp.config("gopls", {
	capabilities = capabilities,
	settings = {
		gopls = {
			analyses = {
				unusedparams = true, -- 检查未使用的参数
				shadow = true, -- 检查变量覆盖
			},
			staticcheck = true, -- 启用 staticcheck[reference:11][reference:12]
			gofumpt = true, -- 使用 gofumpt 进行格式化[reference:13]
			completeUnimported = true, -- 自动补全未导入的包[reference:14]
			usePlaceholders = true, -- 为函数参数使用占位符[reference:15]
			semanticTokens = true, -- 启用语义高亮[reference:16]
			hints = { -- 启用 inlay hints，显示类型等信息
				assignVariableTypes = true,
				compositeLiteralFields = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			codelenses = { -- 启用 CodeLens，在代码上方显示运行测试、整理依赖等快捷操作
				generate = true,
				test = true,
				tidy = true,
			},
		},
	},
})

vim.lsp.config("jdtls", {
    cmd = function()
        local mason_bin = vim.fn.stdpath("data") .. "/mason/packages/jdtls/bin"
        if vim.fn.has("win32") == 1 then
            return { mason_bin .. "jdtls.bat" }
        else
            return { mason_bin .. "jdtls" }
        end
    end,
	filetypes = { "java" },
	root_markers = { ".git", "pom.xml", "build.gradle", "gradlew", "mvnw" },
	init_options = {
		extendedClientCapabilities = {
			classFileContentsSupport = true,
		},
	},
	capabilities = vim.lsp.protocol.make_client_capabilities(),
})

vim.lsp.enable({
	"lua_ls",
	"basedpyright",
	"ruff",
	"perlnavigator",
	"bashls",
	"ts_ls",
	"clangd",
	"jdtls",
})
