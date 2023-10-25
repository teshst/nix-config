{ config, options, lib, pkgs, ... }:

with builtins;
with lib;
with lib.my;
let cfg = config.modules.desktop.styling;
    themeDir = config.dotfiles.themeDir;
in {
  options.modules.desktop.styling = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {

    stylix = {
      image = toPath "${themeDir}/wallpaper.png";
      base16Scheme = config.scheme;

      fonts = {
        serif = stylix.fonts.sansSerif;
      };
    };

  };
}
