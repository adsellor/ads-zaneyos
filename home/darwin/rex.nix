{config, ...}: {
  # Linked to the repo file itself, so edits need only `rex config reload`, not a rebuild
  home.file.".config/rex/init.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Developer/ads-zaneyos/config/rex/init.lua";

  # The stylix colors Ghostty gets, as a Ghostty theme for Rex's Import Theme File
  home.file.".config/rex/themes/Stylix".text = with config.lib.stylix.colors.withHashtag; ''
    background = ${base00}
    foreground = ${base05}
    cursor-color = ${base05}
    selection-background = ${base02}
    selection-foreground = ${base05}
    palette = 0=${base00}
    palette = 1=${base08}
    palette = 2=${base0B}
    palette = 3=${base0A}
    palette = 4=${base0D}
    palette = 5=${base0E}
    palette = 6=${base0C}
    palette = 7=${base05}
    palette = 8=${base03}
    palette = 9=${base08}
    palette = 10=${base0B}
    palette = 11=${base0A}
    palette = 12=${base0D}
    palette = 13=${base0E}
    palette = 14=${base0C}
    palette = 15=${base07}
  '';

  # Font size for new tabs and panes, as in Ghostty; ⌘+ and ⌘- only zoom one pane
  targets.darwin.defaults."com.superlogical.rex"."Workspace.terminalFontPointSize" = 16.0;
}
