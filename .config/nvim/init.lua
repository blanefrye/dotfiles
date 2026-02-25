-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { "Mofiqul/dracula.nvim", lazy = false, priority = 1000 },
    { "nvim-treesitter/nvim-treesitter", lazy = false, build = ":TSUpdate" },
    {
      "akinsho/bufferline.nvim",
      lazy = false,
      opts = {
        options = {
          diagnostics = "nvim_lsp",
          show_close_icon = false,
          show_buffer_close_icons = false,
          show_buffer_icons = false,
          max_name_length = 50,
          name_formatter = function(buf)
            return vim.fn.fnamemodify(buf.path, ":t")
          end,
        },
      },
    },
    {
      "nvim-telescope/telescope.nvim",
      tag = "v0.2.1",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
      },
      keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>" },
        { "<leader>fe", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>" },
      },
      config = function(_, opts)
        require("telescope").setup(opts)
        require("telescope").load_extension("file_browser")
      end,
      opts = {
        defaults = {
          layout_strategy = "horizontal",
          layout_config = {
            width = 0.9,
            height = 0.9,
            preview_width = 0.5,
          },
          mappings = {
            i = {
              ["<Esc>"] = "close",
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
      },
    },
    { 'alexghergh/nvim-tmux-navigation', config = function()

      local nvim_tmux_nav = require('nvim-tmux-navigation')

      nvim_tmux_nav.setup {
          disable_when_zoomed = true -- defaults to false
      }

      vim.keymap.set('n', "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
      vim.keymap.set('n', "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
      vim.keymap.set('n', "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
      vim.keymap.set('n', "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)

      end
    },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    {
      "hrsh7th/nvim-cmp",
      config = function()
        local cmp = require("cmp")
        cmp.setup({
          snippet = {
            expand = function(args)
              vim.snippet.expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
          }, {
            { name = "buffer" },
          }),
        })
      end,
    },
  },

  -- automatically check for plugin updates
  checker = { enabled = true },
})

vim.cmd.colorscheme("dracula")

vim.lsp.config.clangd = {
  cmd = { "clangd-21", "--query-driver=**/tiarmclang,**/arm-none-eabi-gcc,**/arm-none-eabi-g++" },
  root_markers = { "compile_commands.json", ".clangd", ".git" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
}
vim.lsp.enable("clangd")

vim.diagnostic.config({
  signs = false,
  underline = false,
  virtual_text = false,
})

vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<cr>')
vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>')
vim.keymap.set('n', '<leader>x', '<cmd>bdelete<cr>')

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "h" },
  callback = function()
    vim.treesitter.start()
  end,
})

-- Telescope picker to select a compile_commands.json and restart clangd
local function pick_compile_commands()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  -- Find all compile_commands.json files from the working directory
  local root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
  if root == "" then
    root = "."
  end
  local handle = io.popen('fd -I -L -E buck-out compile_commands.json "' .. root .. '" 2>/dev/null')
  if not handle then return end
  local results = {}
  for line in handle:lines() do
    table.insert(results, line)
  end
  handle:close()

  if #results == 0 then
    vim.notify("No compile_commands.json found", vim.log.levels.WARN)
    return
  end

  pickers.new({}, {
    prompt_title = "Select compile_commands.json",
    finder = finders.new_table({ results = results }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local selected = selection[1]
        local dir = vim.fn.resolve(vim.fn.fnamemodify(selected, ":p:h"))
        vim.notify("Using: " .. dir)
        -- Stop all running clangd clients
        for _, client in ipairs(vim.lsp.get_clients({ name = "clangd" })) do
          client:stop()
        end
        -- Restart clangd with the new compile commands directory
        vim.defer_fn(function()
          vim.lsp.start({
            name = "clangd",
            cmd = { "clangd-21", "--query-driver=**/tiarmclang,**/arm-none-eabi-gcc,**/arm-none-eabi-g++", "--compile-commands-dir=" .. dir },
            root_dir = vim.fn.getcwd(),
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
          })
        end, 500)
      end)
      return true
    end,
  }):find()
end

vim.keymap.set("n", "<leader>cc", pick_compile_commands)
