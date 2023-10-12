{ pkgs, nix-doom-emacs, emacs-overlay, ... }:

{
  imports = [ nix-doom-emacs.hmModule ];

  nixpkgs.overlays = [ emacs-overlay.overlay ];

  home.sessionPath = [ "$XDG_CONFIG_HOME/.emacs.d/bin" ];

  programs.doom-emacs = {
     enable = true;
     doomPrivateDir = ./.doom.d;
  };

  services.emacs.enable = true;
}
