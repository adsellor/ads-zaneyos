{ username, pkgs, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  imports = [
    ./nixvim/default.nix
    ./bat.nix
    ./btop.nix
    ./fastfetch.nix
    ./fish.nix
    ./starship.nix
    ./git.nix
    ./gh.nix
    ./newsboat.nix
    ./zathura.nix
    ./ripgrep.nix
    ./zellij.nix
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];

  home.packages = with pkgs; [
    telegram-desktop
    signal-desktop-bin
  ];

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
       hidePodcasts
       shuffle
     ];
  };

  home.username = "${username}";
  home.stateVersion = "23.11";
}
