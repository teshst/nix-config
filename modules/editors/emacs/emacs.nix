
{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.emacs;
    configDir = config.dotfiles.configDir;
in {
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
