
{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.emacs;
    configDir = config.dotfiles.configDir;
in {
  imports = [ inputs.nix-doom-emacs.hmModule ];

  options.modules.editors.emacs = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {

    programs.doom-emacs = {
      enable = true;
      doomPrivateDir = ./doom.d;
    };

    services.emacs.enable = true;
  };
}
