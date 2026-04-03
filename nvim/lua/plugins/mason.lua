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
    -- 2. mason-tool-installer: 插件会在nvim启动时自动检查并安装缺失的 Lsp Server, linter, formatter
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = {
                -- LSP
                "lua-language-server",
                "pyright",
                "ruff",
                "bash-language-server",
                "perlnavigator",
                "clangd",
                -- Formatters / Linters
                "stylua",
                "prettier",
            },
            auto_update = true,
            run_on_start = true,
        }
    },
}
