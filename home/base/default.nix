{ username, pkgs, inputs, ... }:
let
  inherit (import ./variables.nix) gitUsername gitEmail;
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
    ./ghostty.nix
    ./zathura.nix
    ./zellij.nix
    inputs.spicetify-nix.homeManagerModules.spicetify
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
