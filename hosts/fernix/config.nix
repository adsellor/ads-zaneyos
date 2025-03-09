{ config
, pkgs
, host
, username
, options
, inputs
, ...
}:
let
  inherit (import ./variables.nix) keyboardLayout;
in
{
  imports = [
    ./hardware.nix
    ./users.nix
    ../../modules/amd-drivers.nix
    ../../modules/nvidia-drivers.nix
    ../../modules/nvidia-prime-drivers.nix
    ../../modules/intel-drivers.nix
    ../../modules/vm-guest-services.nix
    ../../modules/local-hardware-clock.nix
  ];

  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_cachyos;
    # This is for OBS Virtual Cam Support
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    # Needed For Some Steam Games
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };
    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    plymouth.enable = true;
  };

  # Styling Options
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
    #   base03 = "#7b7c8c"; # Comments, Invisibles, Line Highlighting
    #   base04 = "585b70"; # Dark Foreground (Used for status bars)
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

    # E-INK
    # base16Scheme = {
    #   # Background and grayscale progression
    #   base00 = "CCCCCC";  # Background white
    #   base01 = "BEBEBE";  # Lighter gray
    #   base02 = "B0B0B0";  # Light gray
    #   base03 = "969696";  # Medium gray
    #   base04 = "787878";  # Medium dark gray
    #   base05 = "5A5A5A";  # Dark gray
    #   base06 = "474747";  # Primary black
    #   base07 = "333333";  # Secondary black
    #   # Neutral tones based on primary colors
    #   base08 = "4D4D4D";  # Slightly warmer black
    #   base09 = "424242";  # Mixed neutral
    #   base0A = "3D3D3D";  # Cooler dark tone
    #   base0B = "383838";  # Deep neutral
    #   base0C = "363636";  # Dark neutral
    #   base0D = "353535";  # Very dark neutral
    #   base0E = "343434";  # Almost secondary black
    #   base0F = "333333";  # Secondary black match
    # };

    # E-INK cosmic mocha fusion

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
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
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

  # Extra Module Options
  drivers.amdgpu.enable = false;
  drivers.nvidia.enable = true;
  drivers.nvidia-prime = {
    enable = true;
    intelBusID = "PCI:0:2:0";
    nvidiaBusID = "PCI:1:0:0";
  };
  drivers.intel.enable = true;
  vm.guest-services.enable = false;
  local.hardware-clock.enable = false;

  networking.networkmanager = {
    enable = true;

    settings = {
      iot = {
        enabled = false;
        "bind-port" = 0;
      };
    };
  };
  networking.hostName = host;
  networking.hosts = {
    "127.0.0.1" = ["kubernetes.docker.internal" "kube.local.dev" "keycloak.local" "mnrv.local"];
  };
  networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];

  # Set your time zone.
  time.timeZone = "Asia/Yerevan";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  programs = {
    firefox.enable = true;
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        buf = {
          symbol = " ";
        };
        c = {
          symbol = " ";
        };
        directory = {
          read_only = " 󰌾";
        };
        docker_context = {
          symbol = " ";
        };
        fossil_branch = {
          symbol = " ";
        };
        git_branch = {
          symbol = " ";
        };
        golang = {
          symbol = " ";
        };
        hg_branch = {
          symbol = " ";
        };
        hostname = {
          ssh_symbol = " ";
        };
        lua = {
          symbol = " ";
        };
        memory_usage = {
          symbol = "󰍛 ";
        };
        meson = {
          symbol = "󰔷 ";
        };
        nim = {
          symbol = "󰆥 ";
        };
        nix_shell = {
          symbol = " ";
        };
        nodejs = {
          symbol = " ";
        };
        ocaml = {
          symbol = " ";
        };
        package = {
          symbol = "󰏗 ";
        };
        python = {
          symbol = " ";
        };
        rust = {
          symbol = " ";
        };
        swift = {
          symbol = " ";
        };
        zig = {
          symbol = " ";
        };
      };
    };
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    virt-manager.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
        tumbler
      ];
    };
    coolercontrol = {
      enable = true;
      nvidiaSupport = true;
    };

    nix-ld = {
      enable = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
     (final: prev: {
      _7zz = prev._7zz.override { useUasm = true; };
    })
  ];

  users = {
    mutableUsers = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    killall
    eza
    git
    cmatrix
    lolcat
    htop
    libvirt
    lxqt.lxqt-policykit
    lm_sensors
    unzip
    unrar
    libnotify
    v4l-utils
    ydotool
    duf
    ncdu
    wl-clipboard
    pciutils
    ffmpeg
    socat
    cowsay
    ripgrep
    lshw
    bat
    pkg-config
    meson
    hyprpicker
    ninja
    brightnessctl
    virt-viewer
    swappy
    appimage-run
    networkmanagerapplet
    yad
    inxi
    playerctl
    nh
    nixfmt-rfc-style
    discord
    libvirt
    swww
    grim
    slurp
    file-roller
    swaynotificationcenter
    imv
    mpv
    gimp
    pavucontrol
    tree
    spotify
    greetd.tuigreet
    firefox
    inputs.zen-browser.packages."${system}".default
    gcc
    bun
    rustup
    libcap
    go
    gcc
    coolercontrol.coolercontrol-gui
    ghostty
    virtualgl
    mesa
    gnu-shepherd
    vulkanPackages_latest.vulkan-extension-layer
    vulkanPackages_latest.vulkan-tools
  ];

  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      noto-fonts-cjk-sans
      font-awesome
      # Commenting Symbola out to fix install this will need to be fixed or an alternative found.
      symbola
      material-icons
    ];
  };

  environment.variables = {
    ZANEYOS_VERSION = "2.2";
    ZANEYOS = "true";
  };

  # Extra Portal Configuration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
  };

  # Services to start
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "${keyboardLayout}";
        variant = "dvp,";
      };
    };
    greetd = {
      enable = true;
      vt = 3;
      settings = {
        default_session = {
          # Wayland Desktop Manager is installed only for user ryan via home-manager!
          user = username;
          # .wayland-session is a script generated by home-manager, which links to the current wayland compositor(sway/hyprland or others).
          # with such a vendor-no-locking script, we can switch to another wayland compositor without modifying greetd's config here.
          # command = "$HOME/.wayland-session"; # start a wayland session directly without a login manager
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland"; # start Hyprland with a TUI login manager
        };
      };
    };
    smartd = {
      enable = false;
      autodetect = true;
    };
    libinput.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    openssh.enable = true;
    flatpak.enable = false;
    printing = {
      enable = true;
      drivers = [
        # pkgs.hplipWithPlugin
      ];
    };
    gnome.gnome-keyring.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    ipp-usb.enable = true;
    syncthing = {
      enable = false;
      user = "${username}";
      dataDir = "/home/${username}";
      configDir = "/home/${username}/.config/syncthing";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    rpcbind.enable = false;
    nfs.server.enable = false;
  };
  systemd.services.flatpak-repo = {
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    disabledDefaultBackends = [ "escl" ];
  };

  # Extra Logitech Support
  hardware.logitech.wireless.enable = false;
  hardware.logitech.wireless.enableGraphical = false;

  # Bluetooth Support
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;

  # Security / Polkit
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  # Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Virtualization / Containers
  virtualisation.libvirtd.enable = true;
  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.docker = {
    enable = true;
  };

  # OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  console.keyMap = "us";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
