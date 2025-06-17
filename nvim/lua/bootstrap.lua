-- Install Lazy.nvim automatically if it's not installed(Bootstraping)
-- Hint: string concatenation is done by `..`
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- After installation, run `checkhealth lazy` to see if everything goes right
-- Hints:
--     build: It will be executed when a plugin is installed or updated
--     config: It will be executed when the plugin loads
--     event: Lazy-load on event
--     dependencies: table
--                   A list of plugin names or plugin specs that should be loaded when the plugin loads.
--                   Dependencies are always lazy-loaded unless specified otherwise.
--     ft: Lazy-load on filetype
--     cmd: Lazy-load on command
--     init: Functions are always executed during startup
--     branch: string?
--             Branch of the repository
--     main: string?
--           Specify the main module to use for config() or opts()
--           , in case it can not be determined automatically.
--     keys: Lazy-load on key mapping (the default mode is 'n', that is normal mode)
--           e.g., { <key mapping>, mode = {'n'}, <function> }
--     opts: The table will be passed to the require(...).setup(opts)
local opts = {
	git = { log = { "--since=3 days ago" } },
	performance = {
		cache = {
			enabled = true,
			path = vim.fn.stdpath("cache") .. "/lazy-cache", -- Caminho explícito
		},

		pkg = {
			enabled = true,
			cache = vim.fn.stdpath("state") .. "/lazy/pkg-cache.lua",
			-- the first package source that is found for a plugin will be used.
			sources = {
				"lazy",
				"rockspec", -- will only be used when rocks.enabled is true
				"packspec",
			},
		},
		rocks = {
			enabled = true,
			root = vim.fn.stdpath("data") .. "/lazy-rocks",
			server = "https://nvim-neorocks.github.io/rocks-binaries/",
		},

		reset_packpath = true, -- reset the package path to improve startup time
		rtp = {
			disabled_plugins = {
				"2html_plugin",
				"editorconfig",
				"getscript",
				"getscriptPlugin",
				"gzip",
				"loaded_remote_plugins",
				"loaded_tutor_mode_plugin",
				"logipat",
				"netrwFileHandlers",
				"netrwPlugin",
				"rplugin",
				"rrhelper",
				"tarPlugin",
				"tohtml",
				"tutor",
				"vimball",
				"vimballPlugin",
				"zip",
				"zipPlugin",
			},
		},
	},
	checker = {
		enabled = true,
		notify = false,
		concurrency = 4,
	},
	reload_on_compiled = false,
	reload_on_config_change = false,
	-- reload_on_config_change = {
	--   nvim_home .. '/init.lua',
	--   nvim_home .. '/lua/**',
	-- },
	install = { colorscheme = { "ayu", "habamax" } },
	log = {
		level = "error", -- Suppress most messages, only show errors
	},
	change_detection = {
		enabled = false,
		notify = false,
	},
}

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
}, opts)
