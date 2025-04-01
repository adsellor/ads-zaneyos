{ pkgs, username, ... }:
let
  inherit (import ../../hosts/fern/variables.nix) gitUsername gitEmail;
in
{

  imports = [
	../../config/neovim.nix
  ];
  home.username = "${username}";
  home.stateVersion = "23.11";


  home.file.".config/newsboat" = {
    source = ../../config/newsboat;
    recursive = true;
  };

  programs.git = {
    enable = true;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.gh.enable = true;
  programs.fish = {
      enable = true;
      plugins = [
        { name = "grc"; src = pkgs.fishPlugins.grc.src; }
        { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
        { name = "plugin-git"; src = pkgs.fishPlugins.plugin-git.src; }
        { name = "forgit"; src = pkgs.fishPlugins.forgit.src; }
      ];
      interactiveShellInit = ''
        set fish_greeting
        fish_vi_key_bindings
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      '';
    };

  programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        buf = {
          symbol = " ";
        };
        c = {
          symbol = " ";
        };
        directory = {
          read_only = " 󰌾";
        };
        docker_context = {
          symbol = " ";
        };
        fossil_branch = {
          symbol = " ";
        };
        git_branch = {
          symbol = " ";
        };
        golang = {
          symbol = " ";
        };
        hg_branch = {
          symbol = " ";
        };
        hostname = {
          ssh_symbol = " ";
        };
        lua = {
          symbol = " ";
        };
        memory_usage = {
          symbol = "󰍛 ";
        };
        meson = {
          symbol = "󰔷 ";
        };
        nim = {
          symbol = "󰆥 ";
        };
        nix_shell = {
          symbol = " ";
        };
        nodejs = {
          symbol = " ";
        };
        ocaml = {
          symbol = " ";
        };
        package = {
          symbol = "󰏗 ";
        };
        python = {
          symbol = " ";
        };
        rust = {
          symbol = " ";
        };
        swift = {
          symbol = " ";
        };
        zig = {
          symbol = " ";
        };
      };
    };
}
