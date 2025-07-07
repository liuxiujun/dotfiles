return {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    keys = {
        {
            "<leader>cf",
            function()
                require("conform").format({ timeout_ms = 10000 })
            end,
            mode = { "n", "v" },
            desc = "[C]ode [F]format",
        },
    },
    opts = {
        default_format_opts = {
            timeout_ms = 10000,
            async = false,           -- not recommended to change
            quiet = false,           -- not recommended to change
            lsp_format = "fallback", -- not recommended to change
        },
        formatters_by_ft = {
            lua = { "stylua" },
            sh = { "shfmt" },
            bash = { "shfmt" },
            c = { "clang-format" },
            cpp = { "clang-format" },
            java = { "google-java-format" },
            python = { "isort", "black" },
            perl = { "perltidy" },
            vue = { "prettier", "eslint_d" },
            javascript = { "prettier", "eslint_d" },
            typescript = { "prettier", "eslint_d" },
            html = { "prettier" },
            css = { "prettier" },
            scss = { "prettier" },
            json = { "prettier" },
        },
        -- The options you set here will be merged with the builtin formatters.
        -- You can also define any custom formatters here.
        --@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
        formatters = {
            injected = { options = { ignore_errors = true } },
            -- # Example of using dprint only when a dprint.json file is present
            -- dprint = {
            --   condition = function(ctx)
            --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
            --   end,
            -- },
            --
            -- # Example of using shfmt with extra args
            -- shfmt = {
            --   prepend_args = { "-i", "2", "-ci" },
            -- },
            eslint_d = {
                condition = function(ctx)
                    -- 只在项目有 eslint 配置时启用
                    return vim.fs.find({ ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json" },
                        { path = ctx.filename, upward = true })[1]
                end,
            },
        },
        format_on_save = false,
    },
}
