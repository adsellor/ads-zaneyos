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
  };

  outputs =
    { nixpkgs, nixpkgs-darwin, nix-darwin, home-manager, chaotic, ... }@inputs:
    let
      linuxSystem = "x86_64-linux";
      linuxHost = "fernix";

      darwinHost = "fern";
      darwinSystem = "aarch64-darwin";

      username = "zaven";

      mkSpecialArgs = system: {
           inherit system inputs username;
           host = if system == linuxSystem then linuxHost else darwinHost;
      };
    in
    {
      nixosConfigurations = {
        "${linuxHost}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit linuxSystem;
            inherit inputs;
            inherit username;
            inherit linuxHost;
          };
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
              home-manager.users.${username} = import ./hosts/${linuxHost}/home.nix;
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
