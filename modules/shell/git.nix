{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.git;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.git = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.programs.git = {
      enable = true;
      userName = "teshst";
      userEmail = "teshpersonal@gmail.com";
      diff-so-fancy.enable = true;
    };
  };
}
