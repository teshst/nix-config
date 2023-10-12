{ pkgs, nix-doom-emacs, emacs-overlay, ... }:

{
  imports = [ nix-doom-emacs.hmModule ];

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
  };

  services.emacs.enable = true;
}
