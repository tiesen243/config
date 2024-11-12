return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-path",
      "onsails/lspkind-nvim",
      "zbirenbaum/copilot-cmp",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
    },
    config = function()
      local cmp = require("cmp")

      require("luasnip.loaders.from_vscode").lazy_load()
      require("copilot_cmp").setup()

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end, { "i", "s", "c" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end, { "i", "s", "c" }),

          ["<C-k>"] = cmp.mapping.scroll_docs(-4),
          ["<C-j>"] = cmp.mapping.scroll_docs(4),

          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-S-Space>"] = cmp.mapping.close(),

          ["<CR>"] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace,
          }),
        },

        sources = {
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
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
      })

      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
      cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local nls = require("null-ls")

      nls.setup({
        sources = {
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.prettier,
        }
      })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter.configs")

      treesitter.setup({
        auto_install = true,
        sync_install = true,
        indent = { enable = true },
        incremental_selection = { enable = true },
        highlight = { enable = true, additional_vim_regex_highlighting = true },
      })

      vim.filetype.add({ extension = { mdx = "mdx", conf = "bash" } })
      vim.filetype.add({ pattern = { [".*/hypr/.*%.conf"] = "hyprlang" } })

      vim.treesitter.language.register("markdown", "mdx")
    end,
  },
  {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      vim.g.skip_ts_context_commentstring_module = true

      require("Comment").setup({
        padding = true,
        sticky = true,
        ignore = nil,
        toggler = {
          line = "<C-/>",
          block = "<C-S-/>",
        },
        opleader = {
          line = "<C-/>",
          block = "<C-S-/>",
        },
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },
  {
    "m4xshen/autoclose.nvim",
    config = function()
      require("autoclose").setup()
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup({
        otps = { enable_close_on_slash = false },
      })
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    lazy = false,
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cmd = "CopilotChat",
    keys = {
      { "<leader>gct", "<cmd>CopilotChatToggle<cr>",        desc = "Toggle Copilot Chat" },
      { "<leader>gce", "<cmd>CopilotChatExplain<cr>",       desc = "Explain code" },
      { "<leader>gcr", "<cmd>CopilotChatReview<cr>",        desc = "Review code" },
      { "<leader>gcf", "<cmd>CopilotChatFix<cr>",           desc = "Fix bug" },
      { "<leader>gco", "<cmd>CopilotChatOptimize<cr>",      desc = "Optimize code" },
      { "<leader>gcd", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "Fix Diagnostic" },
      { "<leader>gcc", "<cmd>CopilotChatCommit<cr>",        desc = "Suggest commit message" },
      { "<leader>gcs", "<cmd>CopilotChatCommitStaged<cr>",  desc = "Suggest commit stage message" },
    },
    config = function()
      require("CopilotChat").setup({
        window = { title = "Copilot Chat", layout = "vertical", width = 0.4 },
      })
    end,
  },
}
