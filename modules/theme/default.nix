{ config, options, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
in {
  options.modules.theme = with types; {
    enable = mkBoolOpt false;

    wallpaper = mkOpt path ./config/wallpaper.png;

    polarity = mkOpt str "dark";
  };

  config = cfg.enable {
  #   inputs.stylix = {
  #     image = cfg.wallpaper;
  #     polarity = cfg.polarity;
  #   };
  };
}
