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

    modules = [
      # set system's scheme to nord by setting `config.scheme`
      { scheme = "${inputs.base16-schemes}/onedark.yaml"; }
    ];

    stylix = {
      image = toPath "${themeDir}/wallpaper.png";
      base16Scheme = scheme;

      fonts = {
        serif = stylix.fonts.sansSerif;
      };

    };

  };
}
