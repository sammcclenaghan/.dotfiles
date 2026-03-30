---@diagnostic disable: missing-fields

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.breakindent = true
vim.opt.wrap = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.textwidth = 80
vim.opt.scrolloff = 8
vim.opt.colorcolumn = "80"
vim.opt.updatetime = 50

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
  virtual_text = { current_line = true },
  float = { border = "rounded", source = true },
})

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- centered jumps
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "J", "mzJ`z")

-- undotree
vim.pack.add({ "https://github.com/mbbill/undotree" })
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undotree" })

-- colorscheme
vim.pack.add({ "https://github.com/ellisonleao/gruvbox.nvim" })
vim.cmd.colorscheme("gruvbox")

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
