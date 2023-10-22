# Theme modules are a special beast. They're the only modules that are deeply
# intertwined with others, and are solely responsible for aesthetics. Disabling
# a theme module should never leave a system non-functional.

{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.themes;
in {
  options.modules.themes = with types; {
    enable = mkBoolOpt false;

    wallpaper = mkOpt path ./config/wallpaper.png;

    gtk = {
      theme = mkOpt str "Dracula";
      iconTheme = mkOpt str "paper";
      cursorTheme = mkOpt str "paper";
    };

    polarity = mkOpt str "dark";

  };

  config = mkIf cfg.enable {
    modules = [ stylix.nixosModules.stylix ];

    inputs.stylix = {
      image = cfg.wallpaper;
      polarity = cfg.polarity;
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
          desktop = 12;
          applications = 15;
          terminal = 15;
          popups = 12;
        };
      };
      opacity = {
        terminal = 0.90;
        applications = 0.90;
        popups = 0.50;
        desktop = 0.90;
      };
    };

    # Desktop theming
    user.packages = with pkgs; [
        dracula-theme
        paper-icon-theme # for rofi
    ];
    fonts = {
      packages = with pkgs; [
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
        "Dracula-purple-solid-kvantum" = {
          recursive = true;
          source = "${pkgs.dracula-theme}/share/themes/Dracula/kde/kvantum/Dracula-purple-solid";
          target = "Kvantum/Dracula-purple-solid";
        };
        "kvantum.kvconfig" = {
          text = "theme=Dracula-purple-solid";
          target = "Kvantum/kvantum.kvconfig";
        };
      })
    ];
  };
}
