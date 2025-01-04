return {
  -- Code Completion
  -- https://github.com/saghen/blink.cmp
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "*",
    event = "InsertEnter",
    opts_extend = { "sources.completion.enabled_providers", "sources.default" },
    opts = {
      appearance = {
        nerd_font_variant = "mono",
        use_nvim_cmp_as_default = false,
        kind_icons = vim.tbl_extend("keep", { Color = "██" }, Yuki.icons.kind),
      },
      completion = {
        ghost_text = { enabled = true },
        accept = { auto_brackets = { enabled = true } },
        menu = { border = "rounded", draw = { treesitter = { "lsp" } } },
        documentation = { auto_show = true, auto_show_delay_ms = 200, window = { border = "rounded" } },
      },
      signature = { enabled = true, window = { border = "rounded" } },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        cmdline = {},
      },
      keymap = {
        preset = "none",
        ["<tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<C-space>"] = { "show", "hide", "fallback" },
        ["<CR>"] = { "select_and_accept", "fallback" },
        ["<C-j>"] = { "scroll_documentation_up", "select_next", "fallback" },
        ["<C-k>"] = { "scroll_documentation_down", "select_prev", "fallback" },
      },
    },
  },

  -- Formatter
  -- https://github.com/nvimtools/none-ls.nvim
  {
    "nvimtools/none-ls.nvim",
    opts = function()
      local nls = require("null-ls")

      nls.setup({
        sources = {
          Yuki.lang.react and nls.builtins.formatting.prettier,
          Yuki.lang.java and nls.builtins.formatting.google_java_format,
          nls.builtins.formatting.shfmt.with({ args = { "-i", "4" } }),
          nls.builtins.formatting.stylua,
        },
      })
    end,
  },

  -- Treesitter
  -- https://github.com/nvim-treesitter/nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "VeryLazy",
    main = "nvim-treesitter.configs",
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    opts = {
      auto_install = true,
      sync_install = true,
      indent = { enable = true },
      highlight = { enable = true, additional_vim_regex_highlighting = true },
    },
  },

  -- Automatically add closing tags for HTML and JSX
  -- https://github.com/windwp/nvim-ts-autotag
  {
    "windwp/nvim-ts-autotag",
    opts = {},
  },

  -- Auto pairs
  -- https://github.com/windwp/nvim-autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { check_ts = true, fast_wrap = {} },
  },

  -- Comment toggler
  -- https://github.com/numToStr/Comment.nvim
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    opts = {
      pre_hook = function()
        return vim.bo.commentstring
      end,
    },
  },
}
