return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local parsers = {
      "c",
      "go",
      "gomod",
      "gosum",
      "javascript",
      "lua",
      "objc",
      "python",
      "typescript",
      "vimdoc",
    }

    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = parsers,
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })
  end,
}
