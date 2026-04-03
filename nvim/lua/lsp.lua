local capabilities = vim.lsp.protocol.make_client_capabilities()

vim.lsp.config("bashls", {
    cmd = { "bash-language-server", "start" }, -- 启动命令
    filetypes = { "sh", "bash" },              -- 作用于哪些文件类型
    root_markers = { ".git", "package.json" }, -- 根目录标记（可选）
    settings = {},                             -- 服务器特定设置
})

vim.lsp.config("perlnavigator", {
    capabilities = capabilities,
    init_options = {
        documentFeatures = {
            "documentSymbol", -- 必须启用
            "folding",
            "syntax"
        }
    },
    settings = {
        perlnavigator = {
            -- Windows 下 perl 通常在 PATH 中，不需要硬编码 /usr/bin/perl
            -- 如果报错找不到 perl，可以改为 "perl" 让系统自己去 PATH 找
            perlPath = vim.fn.has("win32") == 1 and "perl" or "/usr/bin/perl",
            enableWarnings = false,
            perlcriticEnabled = true,
            includePaths = {
                "lib",
                "t",
                -- 【修复核心】安全地获取用户主目录
                (function()
                    local home = os.getenv("HOME") or os.getenv("USERPROFILE")
                    if not home then return "" end -- 防止 nil
                    -- Windows 路径分隔符处理
                    local sep = vim.fn.has("win32") == 1 and "\\" or "/"
                    return home .. sep .. "perl5" .. sep .. "lib" .. sep .. "perl5"
                end)(),
            },
        }
    }
})

vim.lsp.config("pyright", {
    cmd = { "pyright-langserver", "--stdio" }, 
    filetypes = { "python" },
    root_markers = { ".git", ".venv", "pyproject.toml", "pyrightconfig.json" },
    capabilities = capabilities,
    settings = {
        python = {
            pythonPath = (
                function()
                    local venv_path = os.getenv("VIRTUAL_ENV")
                    if venv_path and venv_path ~= "" then
                        return venv_path ..
                            (vim.fn.has("win32") == 1 and "\\Scripts\\python.exe" or "/bin/python")
                    else
                        return vim.fn.exepath("python3") or "python3" -- 系统 Python
                    end
                end
            )(),
            analysis = {
                disableOrganizeImports = true, -- 交给ruff
                extraPaths = {
                    "/usr/lib/python3/dist-packages" -- 添加系统包路径，路径可能因系统而异
                },
            },
        },
    },
})

-- 配置 Ruff 内置语言服务器（负责 linting 和 formatting）
vim.lsp.config("ruff", {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = { ".git", "", "pyproject.toml", "pyrightconfig.json", "ruff.toml", ".ruff.toml" },
    capabilities = capabilities,
    -- 可选：覆盖某些能力，避免与 pyright 重复
    on_attach = function(client, bufnr)
        -- 禁用 hover 能力，让 pyright 提供更好的类型信息
        client.server_capabilities.hoverProvider = false
        -- 可选：保存时自动格式化
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr, async = false })
            end,
        })
    end,
    -- init_options = {
    --     settings = {
    --         -- 你可以在这里配置 ruff 的具体行为，也可以在项目根目录的 ruff.toml 或 pyproject.toml 中配置
    --     },
    -- },
})

vim.lsp.config("ts_ls", {
    filetypes = { "typescript", "javascript" },
})

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim).
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global.
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files.
                library = {
                    -- 1. 添加 Vim 运行时路径
                    vim.api.nvim_get_runtime_file("", true),
                    -- 2. 添加 $VIMRUNTIME/lua 目录
                    vim.fn.expand("$VIMRUNTIME/lua")
                },
            },
            -- Do not send telemetry data containing a randomized but unique identifier.
            telemetry = {
                enable = false,
            },
        },
    },
})

vim.lsp.config("clangd", {
    capabilities = capabilities,
})

vim.lsp.enable({
    "lua_ls",
    "pyright",
    "ruff",
    "perlnavigator",
    "bashls",
    "ts_ls",
    "clangd",
})

