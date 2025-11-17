{pkgs-stable, pkgs, ...}: {
  programs.bat = {
    enable = false;
    package = pkgs.bat;
    config = {
      pager = "less -FR";
    };
    extraPackages = with pkgs.bat-extras; [
      batman
      batpipe
      batgrep
    ];
  };
}
