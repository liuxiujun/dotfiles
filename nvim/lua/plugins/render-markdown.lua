--------------------------------------------------------------------------------
-- 插件名称：MeanderingProgrammer/render-markdown.nvim
-- 功能用途：Markdown 实时美化渲染（在 Normal 模式下直接美化标题、表格、代码块与复选框，Insert 模式下自动还原源码）
--------------------------------------------------------------------------------
return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = "markdown",
	opts = {
		completions = {
			blink = { enabled = true }, -- 开启 blink 补全源
		},
        -- 让markdown中的<!-- ... --> 原样显示出来, 不渲染
        html = {
            comment = {
                conceal = false,
            }
        }
	},
}
