# Theme modules are a special beast. They're the only modules that are deeply
# intertwined with others, and are solely responsible for aesthetics. Disabling
# a theme module should never leave a system non-functional.

{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
in {
  options.modules.theme = with types; {
    active = mkOption {
      type = nullOr str;
      default = null;
      apply = v: let theme = builtins.getEnv "THEME"; in
                 if theme != "" then theme else v;
      description = ''
        Name of the theme to enable. Can be overridden by the THEME environment
        variable. Themes can also be hot-swapped with 'hey theme $THEME'.
      '';
    };

    wallpaper = mkOpt path ./hex/config/wallpaper.png;

    gtk = {
      theme = mkOpt str "";
      iconTheme = mkOpt str "";
      cursorTheme = mkOpt str "";
    };

    polarity = mkOpt str "dark";

    fonts = {
      mono = {
        name = mkOpt str "Monospace";
      };
      sans = {
        name = mkOpt str "Sans";
      };
      size = {
        desktop = mkOpt int 12;
        applications = mkOpt int 15;
        terminal = mkOpt int 15;
        popups = mkOpt int 12;
      };
    };
  };

  config = mkIf (cfg.active != null) (mkMerge [
    {

      inputs.stylix = {
        image = cfg.wallpaper;
        polarity = cfg.polarity;
        fonts = {
          serif = cfg.fonts.sans;
          sansSerif = cfg.fonts.sans;
          monospace = cfg.fonts.mono;
          sizes = {
            desktop = cfg.fonts.size.desktop;
            applications = cfg.fonts.size.applications;
            terminal = cfg.fonts.size.terminal;
            popups = cfg.fonts.size.popups;
          };
        };
        opacity = {
          terminal = 0.90;
          applications = 0.90;
          popups = 0.50;
          desktop = 0.90;
        };
        targets = {
          waybar.enableLeftBackColors = true;
          waybar.enableRightBackColors = true;
        };
      };

      home.configFile = {
        # GTK
        "gtk-3.0/settings.ini".text = ''
          [Settings]
          ${optionalString (cfg.gtk.theme != "")
            ''gtk-theme-name=${cfg.gtk.theme}''}
          ${optionalString (cfg.gtk.iconTheme != "")
            ''gtk-icon-theme-name=${cfg.gtk.iconTheme}''}
          ${optionalString (cfg.gtk.cursorTheme != "")
            ''gtk-cursor-theme-name=${cfg.gtk.cursorTheme}''}
          gtk-fallback-icon-theme=gnome
          gtk-application-prefer-dark-theme=true
          gtk-xft-hinting=1
          gtk-xft-hintstyle=hintfull
          gtk-xft-rgba=none
        '';
        # GTK2 global theme (widget and icon theme)
        "gtk-2.0/gtkrc".text = ''
          ${optionalString (cfg.gtk.theme != "")
            ''gtk-theme-name="${cfg.gtk.theme}"''}
          ${optionalString (cfg.gtk.iconTheme != "")
            ''gtk-icon-theme-name="${cfg.gtk.iconTheme}"''}
          gtk-font-name="Sans ${toString(cfg.fonts.sans.size)}"
        '';
        # QT4/5 global theme
        "Trolltech.conf".text = ''
          [Qt]
          ${optionalString (cfg.gtk.theme != "")
            ''style=${cfg.gtk.theme}''}
        '';
      };

      fonts.fontconfig.defaultFonts = {
        sansSerif = [ cfg.fonts.sans.name ];
        monospace = [ cfg.fonts.mono.name ];
      };
    }
  ]);
}
