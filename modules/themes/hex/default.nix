{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
in {
  config = mkIf (cfg.active == "hex") (mkMerge [
    # Desktop-agnostic configuration
    {
      modules = {
        theme = {
          wallpaper = mkDefault ./config/wallpaper.png;
          gtk = {
            theme = "adw-gtk3";
            iconTheme = "Adwaita";
            cursorTheme = "Adwaita";
          };
          fonts = {
            sans.name = "Fira Sans";
            mono.name = "Fira Code";
          };
          colors = {
            black         = "#1E2029";
            red           = "#ffb86c";
            green         = "#50fa7b";
            yellow        = "#f0c674";
            blue          = "#61bfff";
            magenta       = "#bd93f9";
            cyan          = "#8be9fd";
            silver        = "#e2e2dc";
            grey          = "#5B6268";
            brightred     = "#de935f";
            brightgreen   = "#0189cc";
            brightyellow  = "#f9a03f";
            brightblue    = "#8be9fd";
            brightmagenta = "#ff79c6";
            brightcyan    = "#0189cc";
            white         = "#f8f8f2";

            types.fg      = "#bbc2cf";
            types.panelbg = "#21242b";
            types.border  = "#1a1c25";
          };
        };

        shell.zsh.rcFiles  = [ ./config/zsh/prompt.zsh ];
      };
    }

    # Desktop (X11) theming
    (mkIf config.services.xserver.enable {
      user.packages = with pkgs; [
        adw-gtk3
        gnome.adwaita-icon-theme
      ];
      fonts = {
        fonts = with pkgs; [
          fira-code
          fira-code-symbols
          open-sans
          jetbrains-mono
          siji
          font-awesome
        ];
      };

      # Other dotfiles
      home.configFile = with config.modules; mkMerge [
        (mkIf desktop.apps.rofi.enable {
          "rofi/theme" = { source = ./config/rofi; recursive = true; };
        })
        (mkIf (desktop.hyprland.enable) {
          "dunst/dunstrc".text = import ./config/dunstrc cfg;
        })
      ];
    })
  ]);
}
