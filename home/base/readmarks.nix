{ inputs, pkgs, ... }:
{
  home.packages = [
    inputs.readmarks.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
