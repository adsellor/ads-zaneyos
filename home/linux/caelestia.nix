{ inputs, pkgs, ... }:{
  home.file.".config/caelestia" = {
    source = ../../config/caelestia;
    recursive = true;
  };
  programs.caelestia = {
    enable = true;
    cli.enable = true;
    package = (inputs.caelestia-shell.packages.${pkgs.system}.caelestia-shell.override {
      withCli = true;
      extraRuntimeDeps = with pkgs; [
        kdePackages.kirigami
      ];
    });
  };
}
