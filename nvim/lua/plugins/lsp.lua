-- 返回一个列表，包含所有 LSP 相关的插件及其配置。
--      包括 Mason、lspconfig、cmp（补全）、Lsp-progress、trouble、vue 等。
-- 可以把 LSP 客户端、补全、诊断 UI 整合在一起。

return {
    -- 1. Mason: 安装 LSP 服务器、DAP、Linter 等外部工具
    {
        "mason-org/mason.nvim",
        event = "VeryLazy",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },
    -- 2. mason-tool-installer: 插件会在nvim启动时自动检查并安装确实的工具
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        event = "VeryLazy",
    },
    -- 3. mason-lspconfig: 桥接 mason 和 lspconfig
    {
        "mason-org/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = {
                "stylua",
                "lua_ls",
                "bashls",
                "perlnavigator",
                "pyright",
                "ruff",
                "ts_ls",
                "clangd",
            },
            automatic_installation = true,
            handlers = {},
        },
    },
    -- 3. blink.cmp 自动补全
    {
        "Saghen/blink.cmp",
        dependencies = {
            "xzbdmw/colorful-menu.nvim",
            "rafamadriz/friendly-snippets",
        },
        version = "1.*",
        event = { "InsertEnter", "CmdlineEnter" },
        opts = {
            keymap = {
                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                ["<C-U>"] = { "scroll_documentation_up", "fallback" },
                ["<C-D>"] = { "scroll_documentation_down", "fallback" },
                ["<C-e>"] = { "hide", "fallback" },
                ["<CR>"] = { "accept", "fallback" },
                ["<Tab>"] = {
                    "snippet_forward",
                    "select_next",
                    function(cmp)
                        if has_words_before() or vim.api.nvim_get_mode().mode == "c" then return cmp.show() end
                    end,
                    "fallback",
                },
                ["<S-Tab>"] = {
                    "select_prev",
                    "snippet_backward",
                    function(cmp)
                        if vim.api.nvim_get_mode().mode == "c" then return cmp.show() end
                    end,
                    "fallback",
                },
            },
            completion = {
                list = { selection = { preselect = false } },
                documentation = { auto_show = true },
                menu = {
                    border = "rounded",
                    draw = {
                    columns = { { "kind_icon" }, { "label", gap = 1 } },
                        components = {
                            label = {
                                text = function(ctx) 
                                    return require("colorful-menu").blink_components_text(ctx) end,
                                highlight = function(ctx) 
                                    return require("colorful-menu").blink_components_highlight(ctx) end,
                            },
                        },
                    },
                },
            },
            signature = {
                enabled = true,
            },
            cmdline = {
                completion = {
                    list = { selection = { preselect = false } },
                    menu = {
                        auto_show = true,
                    },
                },
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
        },
        opts_extends = { "source.default" },
    }

    -- 4. nvim-lspconfig: LSP 客户端的核心配置
    -- {
    --     "neovim/nvim-lspconfig",
    --     event = "VeryLazy",
    --     dependencies = {
    --         "williamboman/mason-lspconfig.nvim",
    --         "hrsh7th/cmp-nvim-lsp"
    --     },
    --
    --     -- lazy.nvim 提供的插件延迟加载机制
    --     keys = {
    --         -- LSP 服务器管理
    --         { "<leader>lI", "<cmd>LspInfo<CR>", desc = "Lsp Info" },
    --         { "<leader>lS", "<cmd>LspStart<CR>", desc = "Start LSP server (if not started)" },
    --         { "<leader>lR", "<cmd>LspRestart<CR>", desc = "Restart LSP server" },
    --         { "<leader>lS", "<cmd>LspStop<CR>", desc = "Stop LSP server" },
    --         { "<leader>ll", "<cmd>LspLog<CR>", desc = "Show LSP log" },
    --         { "<leader>lm", "<cmd>Mason<CR>", desc = "Open Mason (LSP installer)" },
    --
    --         -- 诊断导航
    --         { "]d", function() vim.diagnostic.goto_next() end, desc = "Next diagnostic" },
    --         { "[d", function() vim.diagnostic.goto_prev() end, desc = "Previous diagnostic" },
    --         { "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, desc = "Next error" },
    --         { "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, desc = "Previous error" },
    --         { "<leader>cd", vim.diagnostic.open_float, desc = "Show line diagnostics" },
    --         { "<leader>cq", vim.diagnostic.setloclist, desc = "Send diagnostics to loclist" },
    --     },
    --     config = function()
    --         -- 通用 LSP 能力（用于自动补全）
    --         local capabilities = require("cmp_nvim_lsp").default_capabilities()
    --
    --         vim.lsp.config("bashls", {
    --             cmd = { "bash-language-server", "start" }, -- 启动命令
    --             filetypes = { "sh", "bash" },              -- 作用于哪些文件类型
    --             root_markers = { ".git", "package.json" }, -- 根目录标记（可选）
    --             settings = {},                             -- 服务器特定设置
    --         })
    --
    --         vim.lsp.config("perlnavigator", {
    --             capabilities = capabilities,
    --             init_options = {
    --                 documentFeatures = {
    --                     "documentSymbol", -- 必须启用
    --                     "folding",
    --                     "syntax"
    --                 }
    --             },
    --             settings = {
    --                 perlnavigator = {
    --                     -- Windows 下 perl 通常在 PATH 中，不需要硬编码 /usr/bin/perl
    --                     -- 如果报错找不到 perl，可以改为 "perl" 让系统自己去 PATH 找
    --                     perlPath = vim.fn.has("win32") == 1 and "perl" or "/usr/bin/perl",
    --                     enableWarnings = false,
    --                     perlcriticEnabled = true,
    --                     includePaths = {
    --                         "lib",
    --                         "t",
    --                         -- 【修复核心】安全地获取用户主目录
    --                         (function()
    --                             local home = os.getenv("HOME") or os.getenv("USERPROFILE")
    --                             if not home then return "" end -- 防止 nil
    --                             -- Windows 路径分隔符处理
    --                             local sep = vim.fn.has("win32") == 1 and "\\" or "/"
    --                             return home .. sep .. "perl5" .. sep .. "lib" .. sep .. "perl5"
    --                         end)(),
    --                     },
    --                 }
    --             }
    --         })
    --
    --         vim.lsp.config("pyright", {
    --             cmd = { "pyright-langserver", "--stdio" }, 
    --             filetypes = { "python" },
    --             root_markers = { ".git", ".venv", "pyproject.toml", "pyrightconfig.json" },
    --             capabilities = capabilities,
    --             settings = {
    --                 python = {
    --                     pythonPath = (
    --                         function()
    --                             local venv_path = os.getenv("VIRTUAL_ENV")
    --                             if venv_path and venv_path ~= "" then
    --                                 return venv_path ..
    --                                     (vim.fn.has("win32") == 1 and "\\Scripts\\python.exe" or "/bin/python")
    --                             else
    --                                 return vim.fn.exepath("python3") or "python3" -- 系统 Python
    --                             end
    --                         end
    --                     )(),
    --                     analysis = {
    --                         disableOrganizeImports = true, -- 交给ruff
    --                         extraPaths = {
    --                             "/usr/lib/python3/dist-packages" -- 添加系统包路径，路径可能因系统而异
    --                         },
    --                     },
    --                 },
    --             },
    --         })
    --
    --         -- 2. 配置 Ruff 内置语言服务器（负责 linting 和 formatting）
    --         vim.lsp.config("ruff", {
    --             cmd = { "ruff", "server" },
    --             filetypes = { "python" },
    --             capabilities = capabilities,
    --             -- 可选：覆盖某些能力，避免与 pyright 重复
    --             on_attach = function(client, bufnr)
    --                 -- 禁用 hover 能力，让 pyright 提供更好的类型信息
    --                 client.server_capabilities.hoverProvider = false
    --                 -- 可选：保存时自动格式化
    --                 vim.api.nvim_create_autocmd("BufWritePre", {
    --                     buffer = bufnr,
    --                     callback = function()
    --                         vim.lsp.buf.format({ bufnr = bufnr, async = false })
    --                     end,
    --                 })
    --             end,
    --             init_options = {
    --                 settings = {
    --                     -- 你可以在这里配置 ruff 的具体行为，也可以在项目根目录的 ruff.toml 或 pyproject.toml 中配置
    --                 },
    --             },
    --         })
    --
    --         vim.lsp.config("ts_ls", {
    --             filetypes = { "typescript", "javascript" },
    --         })
    --
    --         vim.lsp.config("lua_ls", {
    --             settings = {
    --                 Lua = {
    --                     runtime = {
    --                         -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim).
    --                         version = "LuaJIT",
    --                     },
    --                     diagnostics = {
    --                         -- Get the language server to recognize the `vim` global.
    --                         globals = { "vim" },
    --                     },
    --                     workspace = {
    --                         -- Make the server aware of Neovim runtime files.
    --                         library = vim.api.nvim_get_runtime_file("", true),
    --                     },
    --                     -- Do not send telemetry data containing a randomized but unique identifier.
    --                     telemetry = {
    --                         enable = false,
    --                     },
    --                 },
    --             },
    --         })
    --
    --         vim.lsp.config("clangd", {
    --             capabilities = capabilities,
    --         })
    --
    --         vim.lsp.enable({
    --             "lua_ls",
    --             "pyright",
    --             "ruff",
    --             "perlnavigator",
    --             "bashls",
    --             "ts_ls",
    --             "clangd",
    --         })
    --     end,
    -- },
}
