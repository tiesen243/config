return {
  -- depends on the typescript
  { import = "plugin.lang.typescript" },

  -- add vue to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "vue", "css" } },
  },

  -- setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        volar = { init_options = { vue = { hybridMode = true } } },
        vtsls = {},
      },
    },
  },

  -- Configure tsserver plugin
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      table.insert(opts.servers.vtsls.filetypes, "vue")
      Yuki.extend(opts.servers.vtsls, "settings.vtsls.tsserver.globalPlugins", {
        {
          name = "@vue/typescript-plugin",
          location = Yuki.get_pkg_path("vue-language-server", "/node_modules/@vue/language-server"),
          languages = { "vue" },
          configNamespace = "typescript",
          enableForWorkspaceTypeScriptVersions = true,
        },
      })
    end,
  },
}
