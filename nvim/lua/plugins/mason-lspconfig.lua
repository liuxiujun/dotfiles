return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        "mason-org/mason.nvim",
        "neovim/nvim-lspconfig",
    },
    opts = {
        ensure_installed = { "lua_ls", "bashls", "perlnavigator", "pyright", "ts_ls", "vue_ls" },
        automatic_installation = true,
    },
}
