return {
	'smoka7/hop.nvim',
	version = "*",
    opts = function() 

		local status_ok, hop = pcall(require, "hop")
		if not status_ok then
			vim.notify("hop not found!")
			return
		end

		local directions = require("hop.hint").HintDirection
		vim.keymap.set("", "<leader><leader>w", function()
			hop.hint_words({ direction = directions.AFTER_CURSOR, current_line_only = false })
		end, { remap = true })
		vim.keymap.set("", "<leader><leader>b", function()
			hop.hint_words({ direction = directions.BEFORE_CURSOR, current_line_only = false })
		end, { remap = true })
    end,
}
