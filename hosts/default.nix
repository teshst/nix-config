{lib, nixpkgs, inputs, home-manager, nix-doom-emacs, emacs-overlay, nixos-hardware, hyprland, disko, vars,  ...}:

let
  system = "x86_64-linux";                                  # System Architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;                              # Allow Proprietary Software
  };

  lib = nixpkgs.lib;
in
{
  omen-laptop = lib.nixosSystem {                                # Laptop Profile
    inherit system;
    specialArgs = {
      inherit inputs disko nixos-hardware vars;
    };
    modules = [
      ./omen-laptop
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit inputs vars nix-doom-emacs emacs-overlay;
        };
        home-manager.users.${vars.user}.imports = [ ../users/${vars.user} ];
      }
    ];
  };
}
