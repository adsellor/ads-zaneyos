{ username, lib, pkgs, host, ... }:
{
  imports = [
    ../base/default.nix
    ./devbox.nix
  ];

  home.homeDirectory = lib.mkForce "/Users/${username}";


  programs.fish.shellAliases = {
    fr = "darwin-rebuild switch --flake /Users/${username}/Developer/ads-zaneyos#${host}";
    cfig = "cd /Users/${username}/Developer/ads-zaneyos && nvim .";
    fu = "darwin-rubild switch --hostname ${host} --update /Users/${username}/Developer/ads-zaneyos";
    ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d";
    cat = "bat";
    ls = "eza --icons";
    ll = "eza -lh --icons --grid --group-directories-first";
    la = "eza -lah --icons --grid --group-directories-first";
    ".." = "cd ..";
  };
}
