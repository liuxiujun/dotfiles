-- ftplugin/java.lua
local api = vim.api
local lsp = vim.lsp
local fn = vim.fn

-- 项目根目录检测（与之前相同）
local root_markers = {
	"pom.xml",
	"build.gradle",
	"build.gradle.kts",
	"mvnw",
	"gradlew",
	".git",
	".project",
}
local buf = api.nvim_get_current_buf()
local root_dir = vim.fs.root(buf, root_markers)
if not root_dir then
	return
end

-- 避免重复启动
for _, client in pairs(lsp.get_active_clients()) do
	if client.name == "jdtls" and client.config.root_dir == root_dir then
		return
	end
end

-- Mason 安装目录
local mason_data = fn.stdpath("data") .. "\\mason\\packages"
local jdtls_install = mason_data .. "\\jdtls"
local launcher = jdtls_install .. "\\bin\\jdtls.cmd"

-- 工作数据目录
local workspace_dir = fn.stdpath("cache") .. "\\jdtls\\" .. fn.sha256(root_dir)
fn.mkdir(workspace_dir, "p")

-- 可选 Lombok
local lombok_jar = jdtls_install .. "\\lombok.jar"
local jvm_args = {}
if fn.filereadable(lombok_jar) then
	table.insert(jvm_args, "-javaagent:" .. lombok_jar)
end

-- 构建命令
local cmd = { launcher, "-data", workspace_dir }
for _, arg in ipairs(jvm_args) do
	table.insert(cmd, "--jvm-arg=" .. arg)
end

-- 启动 LSP
lsp.start({
	name = "jdtls",
	cmd = cmd,
	root_dir = root_dir,
	settings = {
		java = {
			configuration = {
				runtimes = {
					{
						name = "JavaSE-21",
						path = "C:\\Users\\liuxi\\scoop\\apps\\temurin21-jdk\\current\\",
					},
				},
			},
			references = { includeDecompiledSources = true },
			format = {
				enabled = true,
				settings = { profile = "GoogleStyle" },
			},
			signatureHelp = { enabled = true },
			saveActions = { organizeImports = true },
		},
	},
	capabilities = lsp.protocol.make_client_capabilities(),
	on_attach = function(client, bufnr)
		-- Codelens 自动刷新
		if client.server_capabilities.codeLensProvider then
			vim.lsp.codelens.refresh()
			api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
				buffer = bufnr,
				callback = vim.lsp.codelens.refresh,
			})
		end
	end,
})
