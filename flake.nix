{
  description = "Tesh's NixOS Config";

  nixConfig.substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
    "https://hyprland.cachix.org"
  ];
  nixConfig.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
  ];

  inputs = {

    #Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";                     # Default Stable Nix Packages

    home-manager = {                                                      # User Package Management
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {                                                          # Official Hyprland flake
      url = "github:hyprwm/Hyprland";                                   # Add "hyprland.nixosModules.default" to the host modules
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Themeing
    stylix.url = "github:danth/stylix";

    # Extras
    emacs-overlay.url  = "github:nix-community/emacs-overlay";
    nixos-hardware.url = "github:teshst/nixos-hardware";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
   inherit (lib.my) mapModules mapModulesRec mapHosts;

   system = "x86_64-linux";

   mkPkgs = pkgs: extraOverlays: import pkgs {
     inherit system;
     config.allowUnfree = true;  # forgive me Stallman senpai
     overlays = extraOverlays ++ (lib.attrValues self.overlays);
   };
   pkgs  = mkPkgs nixpkgs [ self.overlays.default ];

   lib = nixpkgs.lib.extend
    (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });
  in
  {

    lib = lib.my;

    overlays.default =
      final: prev: {
        my = self.packages."${system}";
      };

    overlays.custom =
      final: prev:
        (mapModules ./overlays import);

    packages."${system}" =
      mapModules ./packages (p: pkgs.callPackage p {});

    nixosModules =
      { dotfiles = import ./.; } // mapModulesRec ./modules import;

    nixosConfigurations =
      mapHosts ./hosts { };

    devShells."${system}".default =
      import ./shell.nix { inherit pkgs; };
  };
}
