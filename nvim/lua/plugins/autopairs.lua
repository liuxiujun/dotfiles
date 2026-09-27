--------------------------------------------------------------------------------
-- 插件名称：windwp/nvim-autopairs
-- 功能用途：括号/引号自动成对补全（输入左括号或引号时自动补齐右侧对应符号）
--------------------------------------------------------------------------------
return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
}
