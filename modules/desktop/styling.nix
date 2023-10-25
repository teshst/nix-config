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

    fonts = {
      packages = with pkgs; [
        emacs-all-the-icons-fonts
        dejavu_fonts
        (nerdfonts.override { fonts = [ "FiraCode" ]; })
      ];
      fontconfig.enable = true;
    };

    stylix = {
      image = ./wallpaper.png;
      homeManagerIntegration.autoImport = false;
      polarity = "dark";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";

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
