{pkgs, ...}: {
  programs.nixvim = {
    # Dependencies
    #
    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extrapackages
    extraPackages = with pkgs; [
      stylua
      prettierd
      eslint_d
    ];

    # Autoformat
    # https://nix-community.github.io/nixvim/plugins/conform-nvim.html
    plugins.conform-nvim = {
      enable = true;
      settings = {
        notify_on_error = true;
        format_after_save = # Lua
          ''
           { async = true, lsp_fallback = true }
          '';
        formatters_by_ft = {
          lua = ["stylua"];
          # Conform can also run multiple formatters sequentially
          # python = [ "isort "black" ];
          javascript = {
            __unkeyed-1 = "eslint_d";
            __unkeyed-3 = "prettierd";
            stop_after_first = true;
          };
          javascriptreact = {
            __unkeyed-1 = "eslint_d";
            __unkeyed-3 = "prettierd";
            stop_after_first = true;
          };
          typescript = {
            __unkeyed-1 = "eslint_d";
            __unkeyed-3 = "prettierd";
            stop_after_first = true;
          };
          typescriptreact = {
            __unkeyed-1 = "eslint_d";
            __unkeyed-3 = "prettierd";
            stop_after_first = true;
          };
          json  = ["eslint_d"];
          graphql = ["prettierd"];
          "_" = [
           "squeeze_blanks"
           "trim_whitespace"
          ];
          go = [ "goimports" "gofmt" ];
          zig = [ "zigfmt" ];
          rust  = ["rustfmt"];
        };
      };
    };

    # https://nix-community.github.io/nixvim/keymaps/index.html
    keymaps = [
      {
        mode = "";
        key = "<leader>f";
        action.__raw = ''
          function()
            require('conform').format { async = true, lsp_fallback = true }
          end
        '';
        options = {
          desc = "[F]ormat buffer";
        };
      }
    ];
  };
}
