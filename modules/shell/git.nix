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
    programs.git = {
      enable = true;
      userName  = "GamingTesh";
      userEmail = "teshpersonal@gmail.com";
    };
  };
}
