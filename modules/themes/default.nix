{ config, options, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.themes;
in {
  options.modules.themes = with types; {
    enable = mkBoolOpt false;

    wallpaper = mkOpt path ./config/wallpaper.png;

    polarity = mkOpt str "dark";
  };

  config = cfg.enable {
    inputs.stylix = {
      image = cfg.wallpaper;
      polarity = cfg.polarity;
    };
  };
}
