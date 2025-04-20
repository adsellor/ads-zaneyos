{
  pkgs
, homebrew-core
, homebrew-cask
, username
, ...
}:

{
  system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
  system.defaults.NSGlobalDomain.KeyRepeat = 2;
  system.activationScripts.extraActivation.text = ''
    softwareupdate --install-rosetta --agree-to-license
  '';

  environment.systemPackages = with pkgs; [
    vim
    git
    raycast
    xcodes
    eza
    uutils-coreutils
  ];

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "zaven";
    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
    };
    mutableTaps = false;
  };

  homebrew = {
    enable = true;
    global = {
      autoUpdate = true;
    };
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    casks = ["ghostty" "docker" "stremio" "zen-browser" "beekeeper-studio"];
  };

  nix.package = pkgs.nix;
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes" ];

  networking.hostName = "fern";

  system.stateVersion = 5;

  system.defaults.dock.autohide = true;
  system.defaults.dock.persistent-apps = [
    {
      app = "/Applications/Zen.app";
    }
    {
      app = "/Applications/Ghostty.app/";
    }
    {
      app = "/System/Applications/System Settings.app/";
    }
  ];

  programs.fish.enable = true;

  environment.shells = [pkgs.fish];

  users.users.${username} = {
    shell = pkgs.fish;
    packages = with pkgs; [
      lazygit
      yazi
      jq
      fzf
      grc
      any-nix-shell
      zathura
      zig
      gtypist
    ];
  };

  system.defaults.dock = {
        wvous-tl-corner = 4; # Desktop
        wvous-br-corner = 11; # Dashboard
        wvous-bl-corner = 10; # Sleep
  };
  security.pam.services.sudo_local.touchIdAuth = true;
  system.defaults.screensaver.askForPassword = true;
  system.defaults.screensaver.askForPasswordDelay = 75;

  stylix = {
    enable = true;
    autoEnable = true;
    image = ../../config/wallpapers/pixel-galaxy.png;
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

  base16Scheme = {
      base00 = "CCCCCC";  # Background white
      base01 = "BFB9B6";  # Warmer mocha tint
      base02 = "B2A8A4";  # Light mocha gray
      base03 = "958985";  # Medium mocha gray
      base04 = "786E6A";  # Medium mocha dark
      base05 = "5A524E";  # Dark mocha gray
      base06 = "474747";  # Primary black
      base07 = "333333";  # Secondary black
      # Enhanced mocha tones
      base08 = "634A3E";  # Rich mocha brown
      base09 = "574339";  # Warm coffee
      base0A = "4B3B36";  # Roasted mocha
      base0B = "423735";  # Deep mocha black
      base0C = "3C3534";  # Dark mocha blend
      base0D = "373333";  # Coffee-black blend
      base0E = "353333";  # Near secondary black
      base0F = "333333";  # Secondary black
    };

    polarity = "light";
    opacity.terminal = 0.8;
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
