-- ftplugin/java.lua (跨平台 Java LSP 启动)
local api = vim.api
local lsp = vim.lsp
local fn = vim.fn

-- 判断操作系统
local is_win = fn.has("win32") == 1
local sep = is_win and "\\" or "/"

-- 项目根目录检测
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

-- 避免重复启动（使用新 API）
local existing_clients = lsp.get_clients({ name = "jdtls" })
for _, client in pairs(existing_clients) do
	if client.config.root_dir == root_dir then
		return
	end
end

-- Mason 安装目录
local mason_data = fn.stdpath("data") .. sep .. "mason" .. sep .. "packages"
local jdtls_install = mason_data .. sep .. "jdtls"
local launcher = jdtls_install .. sep .. "bin" .. sep .. (is_win and "jdtls.bat" or "jdtls")

-- 工作数据目录
local workspace_dir = fn.stdpath("cache") .. sep .. "jdtls" .. sep .. fn.sha256(root_dir)
fn.mkdir(workspace_dir, "p")

-- 可选 Lombok
local lombok_jar = jdtls_install .. sep .. "lombok.jar"
local jvm_args = {}
if fn.filereadable(lombok_jar) then
	table.insert(jvm_args, "-javaagent:" .. lombok_jar)
end

-- 构建命令
local cmd = { launcher, "-data", workspace_dir }
for _, arg in ipairs(jvm_args) do
	table.insert(cmd, "--jvm-arg=" .. arg)
end

-- JDK 路径：优先使用 JAVA_HOME 环境变量，否则回退到常见默认值（请按需修改）
local java_home = os.getenv("JAVA_HOME")
if not java_home then
	if is_win then
		java_home = "C:\\Users\\liuxi\\scoop\\apps\\temurin21-jdk\\current\\"
	else
		-- Linux 示例，请改为你的实际 JDK 路径
		java_home = "/usr/lib/jvm/java-17-openjdk-amd64"
	end
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
						path = java_home,
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
