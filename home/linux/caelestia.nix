# { inputs, pkgs, ... }:
# let
#   system = pkgs.stdenv.hostPlatform.system;
#
#   # caelestia-cli's wrapper *prepends* its own gpu-screen-recorder to PATH, so
#   # `caelestia record` always uses that one and never the system profile's.
#   # Both caelestia flakes build from `nixpkgs.legacyPackages`, which carries no
#   # overlays, so the NVENC fix in hosts/fernix/config.nix does not reach it —
#   # inject the overlaid package by hand. See that overlay for why the fix is
#   # needed.
#   caelestia-cli =
#     inputs.caelestia-shell.inputs.caelestia-cli.packages.${system}.default.override
#       { inherit (pkgs) gpu-screen-recorder; };
#
#   caelestia-shell = inputs.caelestia-shell.packages.${system}.caelestia-shell.override {
#     withCli = true;
#     inherit caelestia-cli;
#     hyprland = pkgs.hyprland;
#     extraRuntimeDeps = with pkgs; [
#       kdePackages.kirigami
#     ];
#   };
# in
{
  home.file.".config/caelestia" = {
    source = ../../config/caelestia;
   recursive = true;
  };
  programs.caelestia = {
    enable = true;
    cli.enable = true;
  };
  # # Caelestia hosts plugins inside its own process, so omaplug patches this
  # # package and hands the result back to `programs.caelestia.package`. Setting
  # # that option here as well would be two definitions of one option.
  # programs.omaplug.shellPackage = caelestia-shell;
  #
  # # Caelestia's own settings, which omaplug merges its bar entries into before
  # # writing ~/.config/caelestia/shell.json. The file stays the source of truth;
  # # it is read here rather than symlinked because only one of the two can own
  # # that path.
  # programs.omaplug.shellSettings = builtins.fromJSON (
  #   builtins.readFile ../../config/caelestia/shell.json
  # );
}
