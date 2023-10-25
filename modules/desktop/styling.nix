{ config, options, lib, pkgs, inputs, ... }:

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
      base16Scheme = "${inputs.base16-schemes}/onedark.yaml";

      fonts = {
        serif = config.stylix.fonts.sansSerif;
      };
    };

  };
}
