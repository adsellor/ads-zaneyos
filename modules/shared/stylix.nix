{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = true;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
    # image = ../../config/wallpapers/1261770.png;
    # base16Scheme = {
    #   base00 = "232136";
    #   base01 = "2a273f";
    #   base02 = "393552";
    #   base03 = "6e6a86";
    #   base04 = "908caa";
    #   base05 = "e0def4";
    #   base06 = "e0def4";
    #   base07 = "56526e";
    #   base08 = "eb6f92";
    #   base09 = "f6c177";
    #   base0A = "ea9a97";
    #   base0B = "3e8fb0";
    #   base0C = "9ccfd8";
    #   base0D = "c4a7e7";
    #   base0E = "f6c177";
    #   base0F = "56526e";
    # };

    # base16Scheme = {
    #   base00 = "0b0b0b"; # Default Background
    #   base01 =
    #     "1b1b1b"; # Lighter Background (Used for status bars, line number and folding marks)
    #   base02 = "2b2b2b"; # Selection Background
    #   base03 = "#7b7c8c"; # Comments, Invisibles, Line Highlighting base04 = "585b70"; # Dark Foreground (Used for status bars)
    #   base04 = "908caa";
    #   base05 = "fcfcfc"; # Default Foreground, Caret, Delimiters, Operators
    #   base06 = "f5e0dc"; # Light Foreground (Not often used)
    #   base07 = "b4befe"; # Light Background (Not often used)
    #   base08 =
    #     "f38ba8"; # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    #   base09 =
    #     "fab387"; # Integers, Boolean, Constants, XML Attributes, Markup Link Url
    #   base0A = "f9e2af"; # Classes, Markup Bold, Search Text Background
    #   base0B = "a6e3a1"; # Strings, Inherited Class, Markup Code, Diff Inserted
    #   base0C =
    #     "94e2d5"; # Support, Regular Expressions, Escape Characters, Markup Quotes
    #   base0D =
    #     "A594FD"; # Functions, Methods, Attribute IDs, Headings, Accent color
    #   base0E =
    #     "cba6f7"; # Keywords, Storage, Selector, Markup Italic, Diff Changed
    #   base0F =
    #     "f2cdcd"; # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
    # };
    #
    # base16Scheme = {
    #   base00 = "F5F0ED"; # Background cream white
    #   base01 = "E5DBD5"; # Warm cream tint
    #   base02 = "D0C0B8"; # Light mocha cream
    #   base03 = "B09C92"; # Medium mocha tone
    #   base04 = "8A746A"; # Medium mocha dark
    #   base05 = "664F45"; # Rich mocha brown
    #   base06 = "4D3A30"; # Deep mocha brown
    #   base07 = "2C211B"; # Dark espresso
    #
    #   # Enhanced mocha tones
    #   base08 = "7D533D"; # Rich coffee brown
    #   base09 = "A16B4F"; # Warm cinnamon mocha
    #   base0A = "C58F6D"; # Caramel mocha
    #   base0B = "5E392E"; # Dark roast
    #   base0C = "492E24"; # Espresso blend
    #   base0D = "3C251C"; # Dark chocolate mocha
    #   base0E = "341A12"; # Coffee-black blend
    #   base0F = "211108"; # Deep espresso black
    # };
    polarity = "dark";
    opacity.terminal = 0.7;
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 14;
        desktop = 11;
        popups = 12;
      };
    };
  };
}
