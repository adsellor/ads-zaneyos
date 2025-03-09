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
  };

  outputs =
    { nixpkgs, home-manager, chaotic, ... }@inputs:
    let
      system = "x86_64-linux";
      host = "fernix";
      username = "zaven";
    in
    {
      nixosConfigurations = {
        "${host}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
            inherit inputs;
            inherit username;
            inherit host;
          };
          modules = [
            ./hosts/${host}/config.nix
            inputs.stylix.nixosModules.stylix
            inputs.spicetify-nix.nixosModules.spicetify
            home-manager.nixosModules.home-manager
            chaotic.nixosModules.default
            {
              home-manager.extraSpecialArgs = {
                inherit username;
                inherit inputs;
                inherit host;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${username} = import ./hosts/${host}/home.nix;
            }
          ];
        };
      };
    };
}
