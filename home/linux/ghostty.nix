{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
  };
  home.file.".config/ghostty" = {
    source = ../../config/ghostty;
    recursive = true;
  };
}

