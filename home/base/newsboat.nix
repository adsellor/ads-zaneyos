_: {
  programs.newsboat = {
    enable = true;
    browser = "open";
  };

  home.file.".config/newsboat" = {
    source = ../../config/newsboat;
    recursive = true;
 };
}
