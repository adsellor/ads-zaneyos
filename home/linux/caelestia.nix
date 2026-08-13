{ inputs, pkgs, ... }:
{
  home.file.".config/caelestia" = {
    source = ../../config/caelestia;
    recursive = true;
  };
  programs.caelestia = {
    enable = true;
    cli.enable = true;
    package = (
      inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.caelestia-shell.override {
        withCli = true;
        hyprland = pkgs.hyprland;
        extraRuntimeDeps = with pkgs; [
          kdePackages.kirigami
        ];
      }
    );
  };
}
