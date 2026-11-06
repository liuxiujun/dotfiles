--------------------------------------------------------------------------------
-- 插件名称：olical/conjure
-- 功能用途：Lisp 系语言（Racket/Clojure/Scheme）的交互式 REPL 求值工具
-- 常用按键：\ee (求值光标下表达式)、\er (求值顶层表达式)、\eb (求值整个文件)、\\ (开关结果日志)
--------------------------------------------------------------------------------
-- 打开 .rkt 文件时自动拉起后台 racket REPL 进程，求值就是把表达式文本写进它的 stdin。
-- 完整列表见 :h conjure-mappings
return {
	"olical/conjure",
	ft = { "racket", "scheme", "clojure", "fennel", "janet", "javascript", "typescript" },
	init = function()
		-- Windows 修复：conjure 的 racket 客户端把文件路径原样拼进 ",enter <path>"（auto_enter），
		-- 而 Racket 读取器把 \ 当转义符，C:\Users\... 会被读成 C:Users... 导致 "unknown module"。
		-- enter 依赖模块私有函数、无法从外部覆写，干脆关闭：
		-- 单文件脚本在 REPL 顶层命名空间求值即可，模块级重载用 \ef（见下方 eval-file 覆写）。
		vim.g["conjure#client#racket#stdio#auto_enter"] = false
        -- Visual 模式下同样使用 \ee 执行选中代码（替代默认的大写 \E）
        vim.g["conjure#mapping#eval_visual"] = "ee"
	end,
	config = function()
		-- 1. 覆写 eval-file（\ef）：",require-reloadable <path>" 有同样的反斜杠问题，
		--    发送前把路径转成正斜杠（Racket 在 Windows 上完全接受正斜杠路径）
		local racket_client = require("conjure.client.racket.stdio")
		racket_client["eval-file"] = function(opts)
			return racket_client["eval-str"](vim.tbl_extend("force", opts, {
				code = ",require-reloadable " .. opts["file-path"]:gsub("\\", "/"),
			}))
		end

        -- 2. 补齐 JavaScript 客户端遗漏的 `var` 变量声明 AST 节点
        local js_client = require("conjure.client.javascript.stdio")
        -- 【核心配置】：清空 on-load，打开 JS/TS 文件时不启动后台 Node 进程
        -- 想用 REPL 时，在 buffer 内按 `\cs` (Client Start) 即可手动启动
        js_client["on-load"] = function() end

        local orig_form_node = js_client["form-node?"]
        js_client["form-node?"] = function(node)
            return node:type() == "variable_declaration" or orig_form_node(node)
        end
	end,
}
