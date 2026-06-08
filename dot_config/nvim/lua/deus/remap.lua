vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>")
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "Y", "yy", { desc = "Yank line to system clipboard" })

vim.keymap.set("n", "<leader>cc", ":cclose<CR>", { desc = "Close quickfix", silent = true })

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<leader>u", vim.cmd.Undotree, { desc = "Open undo tree" })

-- compiler stuff
vim.keymap.set("n", "<leader>rp", ":w <bar> exec '!python %'<CR>")
-- vim.keymap.set("n", "<leader>b", ":w <bar> exec '!clang % -o %:r'<CR>")
vim.keymap.set("n", "<leader>b", function()
	vim.cmd("w")

	-- Close existing terminals
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buftype == "terminal" then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end

	-- Change directory to project
	vim.cmd("cd D:/code/personal/handmade_hero/code")

	-- Define the output file
	local error_file = "build_errors.txt"

	-- Run build.bat and redirect output
	vim.fn.jobstart({ "cmd.exe", "/c", "build.bat > " .. error_file .. " 2>&1" }, {
		cwd = "D:/code/personal/handmade_hero/code",
		on_exit = function()
			vim.schedule(function()
				local cur_win = vim.api.nvim_get_current_win()

				vim.cmd("cfile " .. error_file)
				vim.cmd("vertical 90copen")
				vim.cmd("wincmd L")
				-- Return focus to code
				if vim.api.nvim_win_is_valid(cur_win) then
					vim.api.nvim_set_current_win(cur_win)
				end
			end)
		end,
	})
end, { desc = "Build project and show errors" })

vim.keymap.set("n", "<leader>ts", ":w <bar> exec '!tsx %'<CR>")
vim.keymap.set("n", "<leader>m", ":w <bar> exec '!make'<CR>")
vim.keymap.set("n", "<leader>mr", ":w <bar> exec '!make run'<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Close window" })

-- lsp
--
vim.keymap.set("n", "<leader>rn", function()
	local curr_name = vim.fn.expand("<cword>")
	vim.ui.input({ prompt = "Rename to: ", default = "" }, function(new_name)
		if new_name and #new_name > 0 then
			vim.lsp.buf.rename(new_name)
		end
	end)
end, { desc = "LSP: Rename symbol (empty input)" })

vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })

-- Jump to first ERROR in the file
vim.keymap.set("n", "<leader>fe", function()
	vim.diagnostic.jump({
		count = 1,
		severity = vim.diagnostic.severity.ERROR,
	})
end)

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "LSP Format" })
-- vim.keymap.set("n", "<leader>s", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic float" })
