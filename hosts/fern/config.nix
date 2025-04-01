{ pkgs, ... }:

{
  system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
  system.defaults.NSGlobalDomain.KeyRepeat = 2;
  
  environment.systemPackages = with pkgs; [
    vim
    git
  ];
  
  nix.package = pkgs.nix;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  
  programs.zsh.enable = true;
  
  networking.hostName = "fern";
  
  system.stateVersion = 5;
}
