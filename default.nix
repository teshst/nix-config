{ inputs, config, lib, pkgs, ... }:

with lib;
with lib.my;
{
  imports =
    # I use home-manager to deploy files to $HOME; little else
    [ inputs.home-manager.nixosModules.home-manager inputs.nix-doom-emacs.hmModule inputs.hyprland.homeManagerModules.default inputs.stylix.nixosModules.stylix]
    # All my personal modules
    ++ (mapModulesRec' (toString ./modules) import);

  # Common config for all nixos machines; and to ensure the flake operates
  # soundly fs
  environment.variables.DOTFILES = config.dotfiles.dir;
  environment.variables.DOTFILES_BIN = config.dotfiles.binDir;

  # Configure nix and nixpkgs
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
  nix =
    let filteredInputs = filterAttrs (n: _: n != "self") inputs;
        nixPathInputs  = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
        registryInputs = mapAttrs (_: v: { flake = v; }) filteredInputs;
    in {
      package = pkgs.nixFlakes;
      extraOptions = "experimental-features = nix-command flakes";
      nixPath = nixPathInputs ++ [
        "nixpkgs-overlays=${config.dotfiles.dir}/overlays"
        "dotfiles=${config.dotfiles.dir}"
      ];
      registry = registryInputs // { dotfiles.flake = inputs.self; };
      settings = {
        auto-optimise-store = true;
      };
    };
  system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;
  system.stateVersion = "23.11";

  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so we enforce
  # this default behavior here.
  networking.useDHCP = mkDefault false;

  # Use the latest kernel
  boot = {
    loader = {
      efi.canTouchEfiVariables = mkDefault true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.enable = mkDefault true;
    };
  };

  # Just the bear necessities...
  environment.systemPackages = with pkgs; [
    bind
    cached-nix-shell
    git
    neovim
    wget
    gnumake
    unzip
  ];
}
