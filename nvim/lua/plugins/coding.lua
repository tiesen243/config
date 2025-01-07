-- Register filetype and extension for treesitter
vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
  extension = {
    mdx = "markdown",
  },
})
vim.treesitter.language.register("markdown", "mdx")

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("LspFormatting", {}),
  callback = function()
    vim.lsp.buf.format({ timeout = 2000 })
  end,
})

return {
  -- Code Completion
  -- https://github.com/saghen/blink.cmp
  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts_extend = { "sources.completion.enabled_providers", "sources.default" },
    opts = {
      appearance = {
        nerd_font_variant = "mono",
        use_nvim_cmp_as_default = false,
        kind_icons = vim.tbl_extend("keep", { Color = "██" }, Yuki.icons.kind),
      },
      completion = {
        menu = { draw = { treesitter = { "lsp" } } },
        accept = { auto_brackets = { enabled = true } },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 250,
          treesitter_highlighting = true,
          window = { border = "rounded" },
        },
      },
      signature = { enabled = false },

      snippets = Yuki.cmp.use_luasnip and {
        expand = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction)
          require("luasnip").jump(direction)
        end,
      } or {},

      sources = { default = Yuki.cmp.sources, cmdline = {} },
      keymap = {
        preset = "enter",
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
      },
    },
  },

  -- Snippets engine
  -- https://github.com/L3MON4D3/LuaSnip
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    enabled = Yuki.cmp.use_luasnip,
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          -- Replace snippets with luasnip
          for i, v in ipairs(Yuki.cmp.sources) do
            if v == "snippets" then
              Yuki.cmp.sources[i] = "luasnip"
            end
          end
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
        end,
      },
    },
    opts = { history = true, delete_check_events = "TextChanged" },
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
