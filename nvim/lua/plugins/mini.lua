return {
  -- Basics config
  {
    "echasnovski/mini.basics",
    opts = {
      -- Options. Set to `false` to disable.
      options = {
        -- Basic options ('number', 'ignorecase', and many more)
        basic = true,
        -- Extra UI features ('winblend', 'cmdheight=0', ...)
        extra_ui = false,
        -- Presets for window borders ('single', 'double', ...)
        win_borders = "rounded",
      },
      -- Mappings. Set to `false` to disable.
      mappings = {
        -- Basic mappings (better 'jk', save with Ctrl+S, ...)
        basic = true,
        -- Prefix for mappings that toggle common options ('wrap', 'spell', ...).
        -- Supply empty string to not create these mappings.
        option_toggle_prefix = [[\]],
        -- Window navigation with <C-hjkl>, resize with <C-arrow>
        windows = true,
        -- Move cursor in Insert, Command, and Terminal mode with <M-hjkl>
        move_with_alt = true,
      },
      -- Autocommands. Set to `false` to disable
      autocommands = {
        -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
        basic = true,
        -- Set 'relativenumber' only in linewise and blockwise Visual mode
        relnum_in_visual_mode = true,
      },
      silent = false,
    },
  },

  --  mini.indentscope [guides]
  --  https://github.com/echasnovski/mini.indentscope
  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      options = { border = "top", try_as_border = true },
      symbol = "▏",
    },
    config = function(_, opts)
      require("mini.indentscope").setup(opts)

      -- Disable for certain filetypes
      vim.api.nvim_create_autocmd({ "FileType" }, {
        desc = "Disable indentscope for certain filetypes",
        callback = function()
          local ignore_filetypes = { "dashboard", "help", "lazy", "mason", "neo-tree", "notify" }
          if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
            vim.b.miniindentscope_disable = true
          end
        end,
      })
    end,
  },

  -- Comment
  {
    "echasnovski/mini.comment",
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = { enable_autocmd = false },
      },
    },
    opts = {
      options = {
        ignore_blank_line = true,
        start_of_line = true,
        pad_comment_parts = true,
        custom_commentstring = function()
          return require("ts_context_commentstring").calculate_commentstring()
              or vim.bo.commentstring
        end,
      },
      mappings = {
        comment = "<C-/>",
        comment_line = "<C-/>",
        comment_visual = "<C-/>",
        textobject = "<C-/>",
      },
    },
  },
}
