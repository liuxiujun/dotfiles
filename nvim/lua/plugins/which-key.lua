return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
        spec = {
            { "<leader>l", group = "LSP" },
            { "<leader>f", group = "Find" },
            { "<leader>b", group = "Buffer" },
            { "<leader>r", group = "Run" },
            { "<leader>c", group = "Code Action" },
            { "<leader><leader>", group = "Hop To" },
        },
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
