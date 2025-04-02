{pkgs, ...}: {
  programs.ghostty = {
    enable = !pkgs.stdenv.isDarwin;
    package = pkgs.ghostty;
  };
  home.file.".config/ghostty" = {
    source = ../../config/ghostty;
    recursive = true;
  };
}

