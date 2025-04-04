{
  description = "ZaneyOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    fine-cmdline = {
      url = "github:VonHeikemen/fine-cmdline.nvim";
      flake = false;
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, nixpkgs-darwin, nix-darwin, home-manager, chaotic, nix-homebrew, homebrew-core, homebrew-cask, ... }@inputs:
    let
      linuxSystem = "x86_64-linux";
      linuxHost = "fernix";

      darwinHost = "fern";
      darwinSystem = "aarch64-darwin";

      username = "zaven";

      mkSpecialArgs = system: {
        inherit system inputs username nix-homebrew homebrew-cask homebrew-core;
        host = if system == linuxSystem then linuxHost else darwinHost;
      };
    in
    {
      nixosConfigurations = {
        "${linuxHost}" = nixpkgs.lib.nixosSystem {
          specialArgs = mkSpecialArgs linuxSystem;
          modules = [
            ./hosts/${linuxHost}/config.nix
            inputs.stylix.nixosModules.stylix
            inputs.spicetify-nix.nixosModules.spicetify
            home-manager.nixosModules.home-manager
            chaotic.nixosModules.default
            {
              home-manager.extraSpecialArgs = mkSpecialArgs linuxSystem;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${username} = { ... }: {
                imports = [ ./home/linux/default.nix ];
              };
            }
          ];
        };
      };

    darwinConfigurations = {
  "${darwinHost}" = nix-darwin.lib.darwinSystem {
    system = darwinSystem;
    specialArgs = mkSpecialArgs darwinSystem;
    modules = [
      ./hosts/${darwinHost}/config.nix
      home-manager.darwinModules.home-manager
      nix-homebrew.darwinModules.nix-homebrew
      {
        home-manager.extraSpecialArgs = mkSpecialArgs darwinSystem;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.users.${username} = { ... }: {
          imports = [ ./home/darwin/default.nix ];
        };
      }
    ];
  };
    };
    };
}
