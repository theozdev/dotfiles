require("deus.remap")
require("deus.set")

require("deus.lazy_init")
require("deus.theme.ef_dreamish")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local deusGroup = augroup('deus', {})

vim.filetype.add({
  extension = {
    ino = "cpp",
    mm = "objc",
    jsonc = "jsonc"
  }
})

vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.ino",
  callback = function()
    local root = vim.fn.getcwd()
    local clangd_path = root .. "/.clangd"
    if vim.fn.filereadable(clangd_path) == 0 then
      vim.fn.writefile({
        "CompileFlags:",
        "  Add: [",
        "    -x, c++,",
        "    -std=gnu++11,",
        "    -I/Users/oleksandrzhurba/Library/Arduino15/packages/arduino/hardware/avr/1.8.6/cores/arduino,",
        "    -I/Users/oleksandrzhurba/Library/Arduino15/packages/arduino/hardware/avr/1.8.6/variants/standard,",
        "    -I/Users/oleksandrzhurba/Library/Arduino15/packages/arduino/hardware/avr/1.8.6/libraries/Servo/src,",
        "    -I/Users/oleksandrzhurba/Library/Arduino15/packages/arduino/tools/avr-gcc/7.3.0-atmel3.6.1-arduino7/avr/include/",
        "  ]"
      }, clangd_path)
      print("📦 Auto-created .clangd for this Arduino project")
    end
  end,
})


autocmd('LspAttach', {
  group = deusGroup,
  callback = function(e)
    local opts = { buf = e.buf }
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, opts)
  end
})
