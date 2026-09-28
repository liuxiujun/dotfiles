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
	"loctvl842/monokai-pro.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("monokai-pro").setup({
			-- 可选 7 种风格 (filter)：
			--   "pro"       : 默认 Monokai Pro（暖灰紫底）
			--   "classic"   : 经典原版 Monokai
			--   "octagon"   : 偏深蓝紫冷色调
			--   "machine"   : 偏暗青绿冷色调
			--   "ristretto" : 偏深咖啡暖棕色调
			--   "spectrum"  : 纯净深灰底高对比度
			--   "light"     : 亮色模式
			filter = "classic",
			devicons = true, -- 让 nvim-web-devicons 图标也自动适配 Monokai Pro 调色板
		})
		vim.cmd.colorscheme("monokai-pro")
	end,
}
