{ inputs, pkgs, ... }:
{
  programs.nixvim = {
    plugins.octo = {
      enable = true;
      # the fork's provider-layer branch (Bitbucket reviews); `nix flake update octo-nvim` pulls new pushes
      package = pkgs.vimPlugins.octo-nvim.overrideAttrs {
        src = inputs.octo-nvim;
      };
    };
  };
}
