_: {
  programs.newsboat = {
    enable = false;
    browser = "open";
  };

  home.file.".config/newsboat" = {
    source = ../../config/newsboat;
    recursive = true;
 };
}
