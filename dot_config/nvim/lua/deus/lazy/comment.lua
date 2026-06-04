return {
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup()

    vim.keymap.set('n', '<leader>/', 'gcc', { remap = true, silent = true }) -- Ctrl + /
    vim.keymap.set('v', '<leader>/', function()
      local start_line = vim.fn.line("v")
      local end_line = vim.fn.line(".")
      if start_line == end_line then
        vim.cmd('normal gc')  -- line comment
      else
        vim.cmd('normal gb')  -- block comment
      end
    end, { silent = true, noremap = true })
  end
}
