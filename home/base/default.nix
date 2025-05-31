{ username, pkgs, inputs, ... }: {
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
    ./comma.nix
    ./direnv.nix
    ./jj.nix
    ./transmission.nix
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];

  home.packages = with pkgs; [
    telegram-desktop
  ];

  programs.spicetify = {
    enable = true;
  };

  home.username = "${username}";
  home.stateVersion = "23.11";
}
