--------------------------------------------------------------------------------
-- 插件名称：kevinhwang91/nvim-ufo (依赖 promise-async)
-- 功能用途：现代代码折叠增强（美化折叠后的提示文本，高性能保持长文件折叠体验流畅）
-- 常用按键：za (切换当前折叠)、zR (展开所有折叠)、zM (收起所有折叠)
--------------------------------------------------------------------------------
local M = {
    'kevinhwang91/nvim-ufo',
    event = 'BufReadPost',
    dependencies = { 'kevinhwang91/promise-async' },
    opts = {
        filetype_exclude = { 'help', 'alpha', 'dashboard', 'neo-tree', 'Trouble', 'lazy', 'mason' },
    },
    config = function(_, opts)
        vim.api.nvim_create_autocmd('FileType', {
            group = vim.api.nvim_create_augroup('local_detach_ufo', { clear = true }),
            pattern = opts.filetype_exclude,
            callback = function()
                require('ufo').detach()
            end,
        })

        vim.opt.foldlevelstart = 99
        require('ufo').setup(opts)
    end,
}

return M
