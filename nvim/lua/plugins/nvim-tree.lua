--------------------------------------------------------------------------------
-- 插件名称：nvim-tree/nvim-tree.lua
-- 功能用途：左侧项目文件树（支持目录浏览、Git 状态标识、诊断标记以及文件的增删改查）
-- 常用按键：<leader>e (开关文件树)、<leader>o (在文件树中定位当前文件)
--------------------------------------------------------------------------------
return {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    config = function()
        local is_ok, nvim_tree = pcall(require, "nvim-tree")
        if not is_ok then
            return
        end

        -- Hint: :help nvim-tree-default-mappings
        -- setup with some options
        nvim_tree.setup({
            sort_by = "case_sensitive",
            git = {
                enable = true,
                timeout = 10000,
            },
            renderer = {
                group_empty = true,
                icons = {
                    show = {
                        git = true,
                    },
                },
            },
            filters = {
                dotfiles = false,
            },
            diagnostics = {
                enable = true,
            },
            tab = {
                sync = {
                    open = true,  -- 新标签也自动打开文件树
                    close = true, -- 同步关闭所有标签页的文件
                },
            },
            view = {
                width = {
                    min = 20,
                    max = 60,
                    padding = 1,
                },
            },
        })
    end,
    keys = {
        { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "[E]xplorer" },
        { "<leader>o", "<cmd>NvimTreeFindFile<CR>", desc = "Reveal current file" },
    },
}
