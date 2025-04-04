{ 
  pkgs
, homebrew-core
, homebrew-cask
, inputs
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

  homebrew.enable = true;
  homebrew.casks = ["ghostty" "docker" "stremio" "zen-browser" "beekeeper-studio"];


  nix.package = pkgs.nix;
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes" ];
  
  programs.zsh.enable = true;
  
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
}
