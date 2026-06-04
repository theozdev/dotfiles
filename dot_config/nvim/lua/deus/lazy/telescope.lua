return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
  },
  config = function()
    local telescope = require('telescope')

    telescope.setup({
      defaults = {
        file_ignore_patterns = {
          "node_modules",
          "%.hex$",
          "%.elf$",
          "%.eep$",
          "%.bin$",
          "%.o$",
          "%.svg$",
          "%.exe$",
          "%.obj$",
          "%.pdb$",
          "%.lib$",
          "%.dll$",
          "^bin/",
          "%.jpg$",
          "%.jpeg$",
          "%.png$",
        },
        preview = {
          treesitter = false,
        },
      },
    })
    telescope.load_extension("live_grep_args")
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<C-p>', builtin.git_files, {})
    vim.keymap.set('n', '<leader>ps', function()
      builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end)
    vim.keymap.set('n', '<leader>pws', function()
      local word = vim.fn.expand("<cword>")
      builtin.grep_string({ search = word })
    end)
    vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
    vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
    vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
  end
}
