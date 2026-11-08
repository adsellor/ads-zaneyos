{
  pkgs,
  inputs,
  system,
  ...
}: {
  # programs.ghostty = {
  #   enable = true;
  # };
  home.file.".config/monstar" = {
    source = ../../config/ghostty;
    recursive = true;
  };
  home.packages = [
    inputs.monstar.packages.${system}.default
    pkgs.ghostty.terminfo # monstar runs its shell with TERM=xterm-ghostty
  ];
}
