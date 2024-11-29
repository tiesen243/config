return {
  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      { "zbirenbaum/copilot-cmp", opts = {} },
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "onsails/lspkind-nvim",
    },

    opts = function()
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local auto_select = true

      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())

      return {
        auto_brackets = {}, -- configure any filetype to auto add brackets
        preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
        completion = {
          completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.scroll_docs(-4),
          ["<C-j>"] = cmp.mapping.scroll_docs(4),
          ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({
            select = auto_select,
            behavior = cmp.ConfirmBehavior.Replace,
          }),
        }),
        sources = cmp.config.sources({
          { name = vim.g.ai_cmp and "copilot" or nil },
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          format = require("lspkind").cmp_format({
            maxwidth = 50,
            ellipsis_char = "",
            preset = "codicons",
            mode = "symbol_text",
            symbol_map = { Copilot = "" },
          }),
        },
        experimental = { ghost_text = { hl_group = "CmpGhostText" } },
        sorting = defaults.sorting,
      }
    end,
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { lua = { "stylua" }, ["_"] = { "prettier" } },
      format_on_save = { timeout_ms = 500 },
      default_format_opts = {
        timeout_ms = 500,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_format = "fallback", -- not recommended to change
      },
    },
  },

  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    opts = {
      auto_install = true,
      sync_install = true,
      highlight = { enable = true, additional_vim_regex_highlighting = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    opts = {},
  },

  -- auto pairs
  {
    "windwp/nvim-autopairs",
    opts = { check_ts = true, fast_wrap = {} },
  },

  -- colorize hex colors in the buffer
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      --- @type string | "foreground" | "background" | "virtualtext"
      mode = "background", -- Set the display mode.
      virtualtext = "■",
      --- @type boolean | "normal" | "lsp" | "both"
      tailwind = "lsp", -- Enable tailwind colors
    },
  },
}
