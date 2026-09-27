--------------------------------------------------------------------------------
-- 插件名称：olical/conjure
-- 功能用途：Lisp 系语言（Racket/Clojure/Scheme）的交互式 REPL 求值工具
-- 常用按键：\ee (求值光标下表达式)、\er (求值顶层表达式)、\eb (求值整个文件)、\\ (开关结果日志)
--------------------------------------------------------------------------------
-- 打开 .rkt 文件时自动拉起后台 racket REPL 进程，求值就是把表达式文本写进它的 stdin。
-- 完整列表见 :h conjure-mappings
return {
    "olical/conjure",
    ft = { "racket", "scheme", "clojure", "fennel", "janet" },
    init = function()
        -- Windows 修复：conjure 的 racket 客户端把文件路径原样拼进 ",enter <path>"（auto_enter），
        -- 而 Racket 读取器把 \ 当转义符，C:\Users\... 会被读成 C:Users... 导致 "unknown module"。
        -- enter 依赖模块私有函数、无法从外部覆写，干脆关闭：
        -- 单文件脚本在 REPL 顶层命名空间求值即可，模块级重载用 \ef（见下方 eval-file 覆写）。
        vim.g["conjure#client#racket#stdio#auto_enter"] = false
    end,
    config = function()
        -- 覆写 eval-file（\ef）：",require-reloadable <path>" 有同样的反斜杠问题，
        -- 发送前把路径转成正斜杠（Racket 在 Windows 上完全接受正斜杠路径）
        local client = require("conjure.client.racket.stdio")
        client["eval-file"] = function(opts)
            return client["eval-str"](vim.tbl_extend("force", opts, {
                code = ",require-reloadable " .. opts["file-path"]:gsub("\\", "/"),
            }))
        end
    end,
}
