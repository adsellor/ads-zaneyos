{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
  };
  home.file.".config/ghostty" = {
    source = ../../config/ghostty;
    recursive = true;
  };
}

