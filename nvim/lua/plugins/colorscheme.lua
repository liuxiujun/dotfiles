--------------------------------------------------------------------------------
-- 插件名称：tanvirtin/monokai.nvim
-- 功能用途：全局配色主题（Monokai 暗色主题，设置最高优先级在启动时最先加载）
--------------------------------------------------------------------------------
-- return {
--     "tanvirtin/monokai.nvim",
--     lazy = false,
--     priority = 1000,
--     config = function()
--         local colorscheme = "monokai"
--
--         local is_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
--         if not is_ok then
--             vim.notify("colorscheme " .. colorscheme .. " not found!")
--             return
--         end
--     end,
-- }
return {
	"sainnhe/sonokai",
	lazy = false,
	priority = 1000,
	config = function()
		-- 必须在 colorscheme 命令之前设置风格才生效！
		-- 可选 6 种风格：
		--   "default"   : 经典 Monokai
		--   "shusia"    : 对应 Monokai Pro (偏暖紫灰底)
		--   "espresso"  : 对应 Monokai Ristretto (深浓咖啡暖黑底)
		--   "andromeda" : 偏深蓝紫科技感
		--   "atlantis"  : 偏深海蓝底
		--   "maia"      : 偏暗青绿底
		vim.g.sonokai_style = "default"
		vim.g.sonokai_enable_italic = true
		vim.g.sonokai_better_performance = 1
		vim.cmd.colorscheme("sonokai")
	end,
}
