--------------------------------------------------------------------------------
-- 插件名称：mason-org/mason.nvim & WhoIsSethDaniel/mason-tool-installer.nvim
-- 功能用途：外部工具包管理器（自动下载、更新并管理各语言的 LSP 服务端、DAP 调试器与格式化工具）
-- 常用按键：<leader>lM (打开 Mason 管理面板)
--------------------------------------------------------------------------------
return {
    -- 1. Mason: 安装 LSP 服务器、DAP、Linter 等外部工具
    {
        "mason-org/mason.nvim",
        cmd = "Mason",
        event = "VeryLazy",
        keys = {
            { "<leader>lM", "<cmd>Mason<CR>", desc = "Open [M]ason (LSP installer)" },
        },
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
    -- 2. mason-tool-installer: 插件在后台检查并自动安装缺失的 Lsp Server, linter, formatter
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "mason-org/mason.nvim" },
        event = "VeryLazy",
        opts = function()
            local ensure_installed = {
                -- LSP（与 config/lsp.lua 的 vim.lsp.enable 对齐）
                "lua-language-server",
                "basedpyright",
                "ruff",
                "debugpy",
                "js-debug-adapter",
                "bash-language-server",
                "perlnavigator",
                "clangd",
                "typescript-language-server", -- ts_ls
                "intelephense",               -- php
                -- Formatters / Linters（与 conform.nvim 的 formatters_by_ft 对齐）
                "stylua",
                "prettier",
                "shfmt",
                "clang-format",
                -- perltidy 不在 mason 仓库，需自行安装：cpan Perl::Tidy
                "eslint_d",
                "tree-sitter-cli",
            }

            -- 仅当当前环境存在 go 编译器时，才自动安装 Go 相关的工具
            if vim.fn.executable("go") == 1 then
                vim.list_extend(ensure_installed, { "gopls", "goimports", "gofumpt" })
            end

            return {
                ensure_installed = ensure_installed,
                auto_update = false, -- 关闭每次启动时自动全量升级，需要升级时使用 :MasonToolsUpdate
                run_on_start = true, -- 保留自动检查并安装缺失工具的功能
                start_delay = 3000, -- 关键优化：延迟 3 秒后在后台静默执行，完全避开前台首屏交互
                debounce_hours = 12, -- 关键优化：12 小时内最多执行一次，防止频繁开启新窗口重复扫描
                integrations = {
                    ["mason-lspconfig"] = false,
                    ["mason-null-ls"] = false,
                    ["mason-nvim-dap"] = false, -- 关键优化：防止启动时反向强制拉起 mason-nvim-dap
                },
            }
        end,
    },
}
