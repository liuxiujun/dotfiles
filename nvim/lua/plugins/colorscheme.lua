-- return { "ellisonleao/gruvbox.nvim" }
return {
	"tanvirtin/monokai.nvim",
	config = function()
		local colorscheme = "monokai"

		local is_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
		if not is_ok then
			vim.notify("colorscheme " .. colorscheme .. " not found!")
			return
		end
	end,
}
