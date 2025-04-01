_: {
  programs.newsboat = {
    enable = true;
  };

  home.file.".config/newsboat" = {
    source = ../../config/newsboat;
    recursive = true;
 };
}
