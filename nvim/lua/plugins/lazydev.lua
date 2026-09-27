--------------------------------------------------------------------------------
-- 插件名称：folke/lazydev.nvim
-- 功能用途：Neovim Lua 配置开发助手（为 lua_ls 自动注入 vim.* 全局 API 与已安装插件的类型提示）
--------------------------------------------------------------------------------
return {
	"folke/lazydev.nvim",
	ft = "lua",
	cmd = "LazyDev",
	opts = {
		library = {
			-- 当代码中出现 vim.uv 时，自动加载底层 libuv 的类型定义与补全
			-- （其余通过 require("xxx") 引入的插件，lazydev 会自动按需识别，无需在此手动列出）
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	},
}
