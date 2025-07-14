{
  pkgs
, homebrew-core
, homebrew-cask
, username
, lib
, ...
}:

{
  imports = [
 ../../modules/shared/stylix.nix
  ];
  system.primaryUser = "zaven";
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
    apple-sdk
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
      brewfile = true;
    };
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
    casks = ["ghostty"  "stremio" "zen" "beekeeper-studio" "docker"];
  };

  nix.package = pkgs.nix;
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes" ];

  networking.hostName = "fern";

  system.stateVersion = 5;

  programs.fish.enable = true;

  environment.shells = [pkgs.fish];

  users.knownUsers = lib.mkForce [];
  users.knownGroups = lib.mkForce [];
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
      gtypist
    ];
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    dock = {
      autohide  = true;
      wvous-tl-corner = 4; # Desktop
      wvous-br-corner = 11; # Dashboard
      wvous-bl-corner = 10; # Sleep
      persistent-apps = [
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
    };
    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 75;
    };
    finder = {
      QuitMenuItem = true;
    };
  };
}
