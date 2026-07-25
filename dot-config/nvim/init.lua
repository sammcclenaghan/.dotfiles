require("vim._core.ui2").enable({})

vim.g.mapleader = " "

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true


vim.opt.wrap = true
vim.opt.smartindent = true
vim.opt.inccommand = "split"

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.breakindent = true

vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  callback = function()
    vim.hl.on_yank()
  end,
})


vim.keymap.set({"n", "v"}, "<leader>d", [["_d]], { desc = "Delete without yanking" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("v", "<", "<gv", { desc = "Unindent and keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent and keep selection" })

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<leader>re", "<cmd>restart<cr>", { desc = "Restart Neovim"})

vim.pack.add({
  "https://github.com/mbbill/undotree",
  "https://github.com/ellisonleao/gruvbox.nvim",
})

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undotree" })

vim.g.ember_variant = "weekend" -- or "daily"
vim.cmd.colorscheme("ember")
-- treesitter
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" }, { confirm = false })
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" })
require("nvim-treesitter.install").update("all")
require("nvim-treesitter").setup({ auto_install = true })

-- which-key
vim.pack.add({ "https://github.com/folke/which-key.nvim" }, { confirm = false })
require("which-key").setup({
  spec = {
    { "<leader>s", group = "[S]earch", icon = { icon = "", color = "green" } },
  },
})

-- oil
vim.pack.add({ "https://github.com/stevearc/oil.nvim" })
vim.pack.add({ "https://github.com/nvim-tree/nvim-web-devicons" })
require("oil").setup({ view_options = { show_hidden = true } })
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- fff
vim.pack.add({ "https://github.com/dmtrKovalenko/fff.nvim" })

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(event)
    if event.data.updated then
      require("fff.download").download_or_build_binary()
    end
  end,
})

local fff_lib = vim.fn.stdpath("data") .. "/site/pack/core/opt/fff.nvim/target/release/libfff_nvim.dylib"
if vim.fn.filereadable(fff_lib) == 0 then
  require("fff.download").download_or_build_binary()
end

require("fff").setup({ lazy_sync = true, prompt = "  " })

vim.keymap.set("n", "<leader>sf", function() require("fff").find_files() end, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sg", function() require("fff").live_grep() end, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sw", function() require("fff").live_grep({ query = vim.fn.expand("<cword>") }) end, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sd", function() vim.diagnostic.setqflist() end, { desc = "[S]earch [D]iagnostics" })
