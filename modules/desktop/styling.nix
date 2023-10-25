{ config, options, lib, pkgs, ... }:

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
      image = "${themeDir}/wallpaper.png";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";

      fonts = {
        serif = stylix.fonts.sansSerif;
      };

    };

  };
}
