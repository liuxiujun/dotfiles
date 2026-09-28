--------------------------------------------------------------------------------
-- 插件名称：lewis6991/gitsigns.nvim
-- 功能用途：Git 行内差异标记与代码段操作（在行号旁显示增删改竖线、行尾 Blame 及代码块预览/回滚）
-- 常用按键：]h / [h (跳至下/上一处改动)、<leader>gp (预览改动块)、<leader>gb (查看当前行 Blame)、<leader>gr (回滚改动块)
--------------------------------------------------------------------------------
return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
		signs_staged = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
		},
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
			end

			-- 跳转：在 Git 修改块 (Hunk) 之间上下移动（如果在 vimdiff 模式下则保持原生 ]c/[c）
			map("n", "]h", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gs.nav_hunk("next")
				end
			end, "Next Git hunk")

			map("n", "[h", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gs.nav_hunk("prev")
				end
			end, "Prev Git hunk")

			-- 常用操作
			map("n", "<leader>gp", gs.preview_hunk_inline, "Preview Git hunk inline")
			map("n", "<leader>gb", function()
				gs.blame_line({ full = true })
			end, "Git blame line")
			map("n", "<leader>gd", gs.diffthis, "Git diff this file")
			map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", "Stage Git hunk")
			map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset Git hunk")
			map("n", "<leader>gR", gs.reset_buffer, "Reset Git buffer")
		end,
	},
}
