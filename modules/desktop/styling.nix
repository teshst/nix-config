{ config, options, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.styling;
    themeDir = config.dotfiles.themeDir;
in {
  options.modules.desktop.styling = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {

    user.packages = with pkgs; [
      base16-schemes
    ];

    fonts = {
      packages = with pkgs; [
        emacs-all-the-icons-fonts
        dejavu_fonts
        (nerdfonts.override { fonts = [ "FiraCode" ]; })
      ];
      fontconfig.enable = true;
    };

    stylix = {
      extraHomeManagerOptions.targets.xfce = disabled;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";
      image = "${themeDir}/wallpaper.png";
      polarity = "dark";

      fonts = {
          serif = {
              package = pkgs.nerdfonts;
              name = "FiraCode Nerd Font Mono";
          };
          sansSerif = {
              package = pkgs.nerdfonts;
              name = "FiraCode Nerd Font Mono";
          };
          monospace = {
              package = pkgs.nerdfonts;
              name = "FiraCode Nerd Font Mono";
          };
          sizes = {
              desktop = 10;
              applications = 10;
              terminal = 10;
              popups = 10;
          };
      };
    };
  };
}
