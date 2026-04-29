return {
    "nvim-mini/mini.nvim",
    version = false,  -- 使用 main 分支，获取最新更新
    config = function()
        -- 只有你显式 setup 的模块才会被启用
        require('mini.icons').setup()
        require('mini.comment').setup()
        -- 如果你以后想用其他 MINI 模块，也在这里添加 setup
        -- require('mini.ai').setup()
    end
}
