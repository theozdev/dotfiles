return {
	"oskarnurm/koda.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("koda").setup({
			on_highlights = function(hl)
				-- Keep selections distinct from the cursor line and column guides.
				hl.Visual = { fg = "#f1f5eb", bg = "#4a684f" }
				hl.VisualNOS = { link = "Visual" }
			end,
		})
		vim.cmd.colorscheme("koda-moss")
	end,
}
