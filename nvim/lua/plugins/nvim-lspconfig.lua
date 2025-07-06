return {
    {
        "neovim/nvim-lspconfig",

        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp"
        },

        -- How to add an LSP for a specific programming language?
        -- 1. Use `:Mason` to install the corresponding LSP.
        -- 2. Add the configuration below. The syntax is `lspconfig.<name>.setup(...)`
        -- Hint (find <name> here): https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
        config = function()
            -- Set different settings for different languages' LSP.
            -- Support List: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
            local lspconfig = require("lspconfig")
            -- 增强补全能力
            local capabilities = require('cmp_nvim_lsp').default_capabilities({
                textDocument = {
                    completion = {
                        completionItem = {
                            snippetSupport = true,
                            deprecatedSupport = true,
                            preselectSupport = true,
                        }
                    }
                }
            })
            -- Case 1. For CMake Users
            --     $ cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .
            -- Case 2. For Bazel Users, use https://github.com/hedronvision/bazel-compile-commands-extractor
            -- Case 3. If you don't use any build tool and all files in a project use the same build flags
            --     Place your compiler flags in the compile_flags.txt file, located in the root directory
            --     of your project. Each line in the file should contain a single compiler flag.
            -- src: https://clangd.llvm.org/installation#compile_commandsjson
            lspconfig.clangd.setup({})
            lspconfig.bashls.setup({})
            lspconfig.perlnavigator.setup({
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
                        perlPath = "/usr/bin/perl", -- 可以指定 perl 路径，如 "/usr/bin/perl"
                        enableWarnings = false,
                        perlcriticEnabled = true,
                        includePaths = {
                            "lib",
                            "t",
                            os.getenv("HOME") .. "/perl5/lib/perl5", -- 关键！添加用户模块路径
                            -- vim.fn.expand(
                            --     "~/.local/share/nvim/mason/packages/perlnavigator/node_modules/perlnavigator-server/src/perl")
                        },
                    }
                }
            })
            lspconfig.pyright.setup({
                capabilities = capabilities,
            })
            lspconfig.ts_ls.setup({})
            lspconfig.lua_ls.setup({
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
                        "n",
                        "<leader>cgr",
                        vim.lsp.buf.references,
                        { buffer = ev.buf, desc = "Goto references" }
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>ca",
                        vim.lsp.buf.code_action,
                        { buffer = ev.buf, desc = "Code action" }
                    )
                end,
            })
        end,
        keys = {
            -- Because autostart=false above, need to manually start the language server.
            { "<leader>cl", "<cmd>LspStart<CR>",       desc = "Start LSP" },
            { "<leader>ce", vim.diagnostic.open_float, desc = "Open diagnostics/errors" },
            { "]d",         vim.diagnostic.goto_next,  desc = "Next diagnostic/error" },
            { "[d",         vim.diagnostic.goto_prev,  desc = "Prev diagnostic/error" },
        },
    },
}
