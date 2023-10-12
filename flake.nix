{
  description = "Tesh's NixOS Config";

  nixConfig.substituters = [
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
  ];
  nixConfig.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";                     # Default Stable Nix Packages

    home-manager = {                                                      # User Package Management
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:teshst/nixos-hardware";

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";

    hyprland = {                                                          # Official Hyprland flake
      url = "github:hyprwm/Hyprland";                                   # Add "hyprland.nixosModules.default" to the host modules
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, hyprland, nix-doom-emacs, nixos-hardware, disko, ... }@inputs:
  let
    vars = {
     user = "seth";
    };
  in
  {
    nixosConfigurations = (                                               # NixOS Configurations
      import ./hosts {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager hyprland nix-doom-emacs nixos-hardware disko vars;   # Inherit inputs
      }
    );
  };
}
