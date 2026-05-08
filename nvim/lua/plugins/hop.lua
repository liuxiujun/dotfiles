return {
	"smoka7/hop.nvim",
	version = "*",
	-- opts = function()
	-- 	local hop = require("hop")
	-- 	local directions = require("hop.hint").HintDirection
	--
	-- 	vim.keymap.set("", "<leader><leader>w", function()
	-- 		hop.hint_words({ direction = directions.AFTER_CURSOR, current_line_only = false })
	-- 	end, { remap = true })
	-- 	vim.keymap.set("", "<leader><leader>b", function()
	-- 		hop.hint_words({ direction = directions.BEFORE_CURSOR, current_line_only = false })
	-- 	end, { remap = true })
	-- end,
    opts = {
        keys = 'etovxqpdygfblzhckisuran'
    },
    keys = {
		{
			"<leader><leader>w",
            "<cmd>HopWordAC<cr>",
			desc = "Hop Forward to Word",
		},
		{
			"<leader><leader>b",
            "<cmd>HopWordBC<cr>",
			desc = "Hop Backward to Word",
		},
    }
}
