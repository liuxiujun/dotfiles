return {
    {
        "neovim/nvim-lspconfig",

        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp"
        },

        -- 全局（global），在任何缓冲区都有效，不依赖LSP是否启动
        -- 调用 LSP管理命令 或 诊断相关命令
        -- lazy.nvim 提供的插件延迟加载机制
        keys = {
            -- LSP 服务器管理
            { "<leader>lI", "<cmd>LspInfo<CR>", desc = "Lsp Info" },
            { "<leader>lS", "<cmd>LspStart<CR>", desc = "Start LSP server (if not started)" },
            { "<leader>lR", "<cmd>LspRestart<CR>", desc = "Restart LSP server" },
            { "<leader>lS", "<cmd>LspStop<CR>", desc = "Stop LSP server" },
            { "<leader>ll", "<cmd>LspLog<CR>", desc = "Show LSP log" },
            { "<leader>lm", "<cmd>Mason<CR>", desc = "Open Mason (LSP installer)" },

            -- 诊断导航
            { "]d", vim.diagnostic.goto_next, desc = "Next diagnostic" },
            { "[d", vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
            { "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, desc = "Next error" },
            { "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, desc = "Previous error" },
            { "<leader>cd", vim.diagnostic.open_float, desc = "Show line diagnostics" },
            { "<leader>cq", vim.diagnostic.setloclist, desc = "Send diagnostics to loclist" },
        },

        -- How to add an LSP for a specific programming language?
        -- 1. Use `:Mason` to install the corresponding LSP.
        -- 2. Add the configuration below. The syntax is `lspconfig.<name>.setup(...)`
        -- Hint (find <name> here): https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            -- 增强补全能力
            -- local capabilities = require('cmp_nvim_lsp').default_capabilities({
            --     textDocument = {
            --         completion = {
            --             completionItem = {
            --                 snippetSupport = true,
            --                 deprecatedSupport = true,
            --                 preselectSupport = true,
            --             }
            --         },
            --         foldingRange = {
            --             dynamicRegistration = false,
            --             lineFoldingOnly = true,
            --         },
            --     }
            -- })
            -- Case 1. For CMake Users
            --     $ cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .
            -- Case 2. For Bazel Users, use https://github.com/hedronvision/bazel-compile-commands-extractor
            -- Case 3. If you don't use any build tool and all files in a project use the same build flags
            --     Place your compiler flags in the compile_flags.txt file, located in the root directory
            --     of your project. Each line in the file should contain a single compiler flag.
            -- src: https://clangd.llvm.org/installation#compile_commandsjson
            -- lspconfig.clangd.setup({})
            vim.lsp.config("bashls", {
                cmd = { "bash-language-server", "start" }, -- 启动命令
                filetypes = { "sh", "bash" },              -- 作用于哪些文件类型
                root_markers = { ".git", "package.json" }, -- 根目录标记（可选）
                settings = {},                             -- 服务器特定设置
            });

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
                capabilities = capabilities,
                settings = {
                    python = {
                        -- 动态设置 pythonPath：优先用虚拟环境，否则用系统 Python
                        -- 检验path是否生效 :lua print(vim.inspect(require("lspconfig").pyright.get_settings().python.pythonPath))
                        -- lua print(vim.inspect(vim.lsp.get_active_clients()[1].config.settings.python.analysis.extraPaths))
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
                            extraPaths = {
                                "/usr/lib/python3/dist-packages" -- 添加系统包路径，路径可能因系统而异
                            }
                        },
                    },
                },
            })

            vim.lsp.config("ts_ls", {
                filetypes = { "typescript", "javascript" },
            })

            vim.lsp.config("volar", {
                filetypes = { "vue" },
                init_options = {
                    vue = {
                        hybridMode = false,
                    },
                    typescript = {
                        tsdk = vim.fn.expand(
                            "~/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib"),
                    },
                },
                settings = {
                    vue = {
                        autoInsert = {
                            attributeQuotes = true,
                            brackets = true,
                        },
                    },
                },
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
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        -- Do not send telemetry data containing a randomized but unique identifier.
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })

            vim.lsp.enable({
                "lua_ls",
                "pyright",
                "perlnavigator",
                "bashls",
                "ts_ls",
                "volar"
            })

            -- Use LspAttach autocommand to only map the following keys after
            -- the language server attaches to the current buffer
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    vim.keymap.set(
                        "n",
                        "<leader>cgd",
                        vim.lsp.buf.definition,
                        { buffer = ev.buf, desc = "Goto definition" }
                    )
                    vim.keymap.set("n", "<leader>cK", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover help" })
                    vim.keymap.set("n", "<leader>crn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename" })
                    vim.keymap.set(
                        "n", "<leader>cgr",
                        vim.lsp.buf.references,
                        { buffer = ev.buf, desc = "Goto references" }
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>ca",
                        vim.lsp.buf.code_action,
                        { buffer = ev.buf, desc = "Code action" }
                    )

                    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover help" })
                end,
            })
        end,
    },
}
