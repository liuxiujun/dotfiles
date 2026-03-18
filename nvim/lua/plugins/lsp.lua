-- 返回一个列表，包含所有 LSP 相关的插件及其配置。
--      包括 Mason、lspconfig、cmp（补全）、Lsp-progress、trouble、vue 等。
-- 可以把 LSP 客户端、补全、诊断 UI 整合在一起。

return {
    -- 1. Mason: 安装 LSP 服务器、DAP、Linter 等外部工具
    {
        "mason-org/mason.nvim",
        -- -- 在config中手动调用 setup (传统方式)
        -- config = function()
        --     require("mason").setup({
        --         ui = {
        --             icons = {
        --                 package_installed = "✓",
        --                 package_pending = "➜",
        --                 package_uninstalled = "✗",
        --             },
        --         },
        --     })
        -- end,
        
        -- 使用 opts 声明配置（现代方式）
        -- 这是 lazy.nvim 提供的一个语法糖
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },
    -- 2. mason-lspconfig: 桥接 mason 和 lspconfig
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = {
                "stylua",
                "lua_ls",
                "bashls",
                "perlnavigator",
                "pyright",
                "ts_ls",
                "vue_ls"
            },
            automatic_installation = true,
        },
    },
    -- 3. nvim-cmp 自动补全（与 LSP 配合）
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
        },
        event = "InsertEnter",
        opts = function()
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local cmp = require("cmp")
            local defaults = require("cmp.config.default")()
            local luasnip = require("luasnip")
            return {
                completion = { autocomplete = false },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.jumpable(1) then
                            luasnip.jump(1)
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp", priority = 1000 }, -- 确保 LSP 源优先
                    { name = "buffer",   priority = 400 },  -- 缓冲区补全次之
                    { name = "path",     priority = 250 },
                    { name = "luasnip" },
                    -- { name = "mkdnflow" },
                }),
                experimental = {
                    ghost_text = {
                        hl_group = "CmpGhostText",
                    },
                },
                sorting = {
                    priority_weight = 2.0 -- 提高关键字优先级
                },
            }
        end,
    },
    -- 4. nvim-lspconfig: LSP 客户端的核心配置
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
            { "]d", function() vim.diagnostic.goto_next() end, desc = "Next diagnostic" },
            { "[d", function() vim.diagnostic.goto_prev() end, desc = "Previous diagnostic" },
            { "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, desc = "Next error" },
            { "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, desc = "Previous error" },
            { "<leader>cd", vim.diagnostic.open_float, desc = "Show line diagnostics" },
            { "<leader>cq", vim.diagnostic.setloclist, desc = "Send diagnostics to loclist" },
        },
        config = function()
            -- 通用 LSP 能力（用于自动补全）
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local cmp_nvim_lsp = require("cmp_nvim_lsp")
                capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

            -- LspAttach 回调：所有 LSP 功能快捷键在这里设置（buffer-local
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)

                    local opts = { buffer = ev.buf, remap = false }

                    -- 跳转
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("keep", opts, { desc = "Goto definition" }))
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("keep", opts, { desc = "Goto declaration" }))
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("keep", opts, { desc = "Goto implementation" }))
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("keep", opts, { desc = "Goto references" }))
                    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, vim.tbl_extend("keep", opts, { desc = "Goto type definition" }))

                    -- 悬停与签名帮助
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("keep", opts, { desc = "Hover documentation" }))
                    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("keep", opts, { desc = "Signature help" }))

                    -- 代码操作与重构
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("keep", opts, { desc = "Rename symbol" }))
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("keep", opts, { desc = "Code action" }))
                    vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("keep", opts, { desc = "Code action (visual)" }))
                    vim.keymap.set("n", "<leader>cf", function() vim.lsp.buf.format { async = true } end, vim.tbl_extend("keep", opts, { desc = "Format buffer" }))

                    -- 其他实用功能
                    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, vim.tbl_extend("keep", opts, { desc = "Add workspace folder" }))
                    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("keep", opts, { desc = "Remove workspace folder" }))
                    vim.keymap.set("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, vim.tbl_extend("keep", opts, { desc = "List workspace folders" }))

                    -- 获取 client 对象
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)
                    if not client then
                        return
                    end

                    -- 动态获取缓冲区所在服务器的能力，可以设置更精细的快捷键（可选）
                    if client and  client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = ev.buf,
                            callback = vim.lsp.buf.document_highlight,
                            group = vim.api.nvim_create_augroup("LspDocumentHighlight", {}),
                        })
                        vim.api.nvim_create_autocmd("CursorMoved", {
                            buffer = ev.buf,
                            callback = vim.lsp.buf.clear_references,
                            group = vim.api.nvim_create_augroup("LspClearHighlight", {}),
                        })
                    end
                end,
            })

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
        end,
    },
}
