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
    -- 2. mason-tool-installer: 插件会在nvim启动时自动检查并安装缺失的 Lsp Server, linter, formatter
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = {
                -- LSP（与 config/lsp.lua 的 vim.lsp.enable 对齐）
                "lua-language-server",
                "basedpyright",
                "ruff",
                "debugpy",
                "bash-language-server",
                "perlnavigator",
                "clangd",
                "typescript-language-server", -- ts_ls
                "intelephense",               -- php
                "gopls",
                -- Formatters / Linters（与 conform.nvim 的 formatters_by_ft 对齐）
                "stylua",
                "prettier",
                "shfmt",
                "clang-format",
                "goimports",
                "gofumpt",
                -- perltidy 不在 mason 仓库，需自行安装：cpan Perl::Tidy
                "eslint_d",
                "tree-sitter-cli",
            },
            auto_update = true,
            run_on_start = true,
        }
    },
}
