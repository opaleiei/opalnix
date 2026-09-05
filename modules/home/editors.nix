{ config, pkgs, ... }:

{
  # Zed GUI Editor
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "yaml"
      "toml"
      "dockerfile"
      "html"
      "git-firefly"
    ];
    userSettings = {
      ui_font_family = "Maple Mono NF";
      buffer_font_family = "Maple Mono NF";
      buffer_font_size = 14;
      theme = {
        mode = "dark";
        dark = "Kanagawa Wave";
      };
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      terminal = {
        font_family = "Maple Mono NF";
      };
      vim_mode = true;
    };
  };

  # Neovim (Terminal Editor - $EDITOR)
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      kanagawa-nvim
      nvim-treesitter.withAllGrammars
      telescope-nvim
      plenary-nvim
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      lualine-nvim
      nvim-web-devicons
      which-key-nvim
      gitsigns-nvim
    ];

    extraLuaConfig = ''
      -- Basic settings
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      vim.opt.smartindent = true
      vim.opt.termguicolors = true
      vim.opt.cursorline = true
      vim.opt.signcolumn = "yes"
      vim.opt.mouse = "a"

      -- Kanagawa colorscheme
      require('kanagawa').setup({
        theme = "wave",
        background = { dark = "wave", light = "lotus" }
      })
      vim.cmd("colorscheme kanagawa")

      -- Lualine
      require('lualine').setup({
        options = { theme = 'kanagawa' }
      })

      -- Gitsigns
      require('gitsigns').setup()

      -- Telescope Keybindings
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help Tags' })

      -- Autocompletion (nvim-cmp)
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args) require('luasnip').lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
        })
      })

      -- LSP Config
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Setup language servers if present
      local servers = { 'nil_ls', 'marksman', 'dockerls', 'jsonls', 'yamlls' }
      for _, lsp in ipairs(servers) do
        if lspconfig[lsp] then
          lspconfig[lsp].setup({ capabilities = capabilities })
        end
      end
    '';
  };

  # LSP and tools for Neovim / Zed
  home.packages = with pkgs; [
    nil # Nix language server
    nixpkgs-fmt # Nix formatter
    yaml-language-server
    dockerfile-language-server-nodejs
  ];
}
