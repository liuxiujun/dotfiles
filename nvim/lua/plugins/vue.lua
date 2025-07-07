return {
    {
        "posva/vim-vue",
        ft = "vue",
        config = function()
            vim.g.vue_pre_processors = "detect"
            -- 设置 Vue 文件类型检测
            vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
                pattern = "*.vue",
                callback = function()
                    vim.bo.filetype = "vue"
                end,
            })
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        ft = { "vue", "html" },
        config = function()
            require("nvim-ts-autotag").setup({
                filetypes = { "html", "vue" },
            })
        end,
    },
}
