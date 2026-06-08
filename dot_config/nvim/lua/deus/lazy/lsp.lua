return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
  },

  config = function()
    local cmp = require("cmp")
    local cmp_lsp = require("cmp_nvim_lsp")

    -- ===== capabilities =====
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )

    -- ===== format on save =====
    local augroup = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true })

    local biome_format_filetypes = {
      javascript = true,
      javascriptreact = true,
      ["javascript.jsx"] = true,
      typescript = true,
      typescriptreact = true,
      ["typescript.tsx"] = true,
    }

    local function has_biome_client(bufnr)
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = "biome" })) do
        if client:supports_method("textDocument/formatting", bufnr) then
          return true
        end
      end

      return false
    end

    local on_attach = function(client, bufnr)
      if client:supports_method("textDocument/formatting", bufnr) then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            local prefer_biome = biome_format_filetypes[vim.bo[bufnr].filetype] and has_biome_client(bufnr)

            vim.lsp.buf.format({
              bufnr = bufnr,
              async = false,
              filter = function(format_client)
                return not prefer_biome or format_client.name == "biome"
              end,
            })
          end,
        })
      end
    end
    -- ==========================

    -- ===== filetypes: treat .vs/.fs as GLSL =====
    vim.filetype.add({
      extension = {
        vs = "glsl",
        fs = "glsl",
        vert = "glsl",
        frag = "glsl",
        comp = "glsl",
        geom = "glsl",
        tesc = "glsl",
        tese = "glsl",
      },
    })

    -- ===== root_dir helper (replacement for lspconfig.util.root_pattern) =====
    local function root_pattern(...)
      local patterns = { ... }
      return function(bufnr, on_dir)
        on_dir(vim.fs.root(bufnr, patterns) or vim.uv.cwd())
      end
    end

    require("fidget").setup({})

    -- ===== mason =====
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "clangd",
        "cssls",
        "ts_ls",
        "biome",
        "jsonls",
        "zls",
        "glsl_analyzer",
      },
    })

    -- ===== per-server configs (Neovim 0.11+ native) =====

    -- sourcekit (Swift) - not managed by mason usually, but we can still configure+enable it
    vim.lsp.config("sourcekit", {
      cmd = { "xcrun", "sourcekit-lsp" },
      filetypes = { "swift", "objective-c", "objective-cpp" },
      root_dir = root_pattern("Package.swift", ".git"),
      capabilities = capabilities,
      on_attach = on_attach,
    })
    vim.lsp.enable("sourcekit")

    -- default config for most mason servers
    local default = {
      capabilities = capabilities,
      on_attach = on_attach,
    }

    -- Configure defaults for servers you didn't override below:
    local mason_servers = {
      "lua_ls",
      "rust_analyzer",
      "gopls",
      "clangd",
      "cssls",
      "ts_ls",
      "biome",
      "jsonls",
      "zls",
      "glsl_analyzer",
    }

    for _, name in ipairs(mason_servers) do
      vim.lsp.config(name, default)
    end

    -- zls override
    vim.lsp.config("zls", {
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = root_pattern(".git", "build.zig", "zls.json"),
      settings = {
        zls = {
          enable_inlay_hints = true,
          enable_snippets = true,
          warn_style = true,
        },
      },
    })
    vim.g.zig_fmt_parse_errors = 0
    vim.g.zig_fmt_autosave = 0

    -- lua_ls override
    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          runtime = { version = "Lua 5.1" },
          diagnostics = {
            globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
          },
        },
      },
    })

    -- clangd override
    vim.lsp.config("clangd", {
      capabilities = capabilities,
      on_attach = on_attach,
      cmd = { "clangd", "--header-insertion=never" },
      filetypes = { "c", "cpp", "objc", "ino" },
      root_dir = root_pattern(".clangd", "compile_commands.json", ".git", "Makefile"),
    })

    -- ts_ls override
    vim.lsp.config("ts_ls", {
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
      root_dir = root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
      single_file_support = true,
    })

    -- jsonls override
    vim.lsp.config("jsonls", {
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "json", "jsonc" },
      settings = {
        json = {
          validate = { enable = true },
        },
      },
    })

    -- glsl_analyzer (you can add settings later; this is enough to attach)
    vim.lsp.config("glsl_analyzer", {
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "glsl" },
    })

    -- finally enable all mason-managed servers
    for _, name in ipairs(mason_servers) do
      vim.lsp.enable(name)
    end

    -- ===== cmp (unchanged) =====
    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      window = {
        completion = { max_height = 20 },
        documentation = { max_height = 20 },
      },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif require("luasnip").expand_or_jumpable() then
            require("luasnip").expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif require("luasnip").jumpable(-1) then
            require("luasnip").jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
      }, {
        { name = "buffer" },
      }),
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline({
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            cmp.complete()
          end
        end, { "c" }),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
      }),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })

    -- ===== diagnostics / hover (unchanged) =====
    vim.diagnostic.config({
      virtual_text = {
        prefix = "●",
        spacing = 4,
        wrap = true,
        max_width = 50,
      },
      float = {
        max_width = 50,
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end,
}
