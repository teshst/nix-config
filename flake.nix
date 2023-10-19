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

    #stylix.url = "github:danth/stylix";

    # base16-schemes = {
    #   url = "github:tinted-theming/base16-schemes";
    #   flake = false;
    # };
  };

  outputs = { self, nixpkgs, nix-doom-emacs, hyprland, ... }@inputs:
  let
   inherit (lib.my) mapModules mapModulesRec mapHosts;

   system = "x86_64-linux";

   mkPkgs = pkgs: extraOverlays: import pkgs {
     inherit system;
     config.allowUnfree = true;  # forgive me Stallman senpai
     overlays = extraOverlays ++ (lib.attrValues self.overlays);
   };
   pkgs  = mkPkgs nixpkgs [ self.overlay ];
   pkgs' = mkPkgs nixpkgs [];

   lib = nixpkgs.lib.extend
    (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });
  in
  {


    modules = [
      nix-doom-emacs.hmModule
      hyprland.homeManagerModules.default
    ];

    lib = lib.my;

    overlay =
      final: prev: {
        my = self.packages."${system}";
      };

    overlays =
      mapModules ./overlays import;

    nixosModules =
      { dotfiles = import ./.; } // mapModulesRec ./modules import;

    nixosConfigurations =
      mapHosts ./hosts {};  };
}
