{ username, lib, ... }:
{
  imports = [
    ../base/default.nix
  ];

  home.homeDirectory = lib.mkForce "/Users/${username}";
  
  programs.fish.shellAliases = {
    fr = "darwin-rebuild switch --flake /Users/${username}/zaneyos";
  };
}
