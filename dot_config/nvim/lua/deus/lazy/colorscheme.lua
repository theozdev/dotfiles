function ColorMyPencils(color)
  color = color or "adwaita"
  vim.cmd.colorscheme(color)

  -- Style only the float windows (like LSP hovers)
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e2e", fg = "#cdd6f4" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1e1e2e", fg = "#f38ba8" })

  -- Ensure main UI is transparent
  --[[ vim.api.nvim_set_hl(1, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(1, "NormalNC", { bg = "none" })
  vim.api.nvim_set_hl(1, "SignColumn", { bg = "none" })
  vim.api.nvim_set_hl(1, "VertSplit", { bg = "none" })
  vim.api.nvim_set_hl(1, "StatusLine", { bg = "none" }) ]]

end

return {}
--[[ return {
  {
    "Mofiqul/adwaita.nvim",
    lazy = false,
    name = "adwaita",
    priority = 1000,
    config = function()
      vim.g.adwaita_darker = true
      ColorMyPencils()
    end,
  },
} ]]
