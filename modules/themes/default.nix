# Theme modules are a special beast. They're the only modules that are deeply
# intertwined with others, and are solely responsible for aesthetics. Disabling
# a theme module should never leave a system non-functional.

{ options, config, lib, pkgs, stylix, base16_schemes, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
in {
    options.modules.theme = {
      enable = mkBoolOpt false;

      gtk = {
        theme = mkOpt str "";
        iconTheme = mkOpt str "";
        cursorTheme = mkOpt str "";
      };
    };


    config = mkIf cfg.enable
    {

     #  stylix.image = ./ign_astronaut.png;
     #  stylix.polarity = "dark";
     # # stylix.base16Scheme = "${inputs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

     #  stylix.fonts = {
     #    serif = {
     #      package = pkgs.dejavu_fonts;
     #      name = "DejaVu Serif";
     #    };

     #    sansSerif = {
     #      package = pkgs.dejavu_fonts;
     #      name = "DejaVu Sans";
     #    };

     #    monospace = {
     #      package = pkgs.dejavu_fonts;
     #      name = "DejaVu Sans Mono";
     #    };

     #    emoji = {
     #      package = pkgs.noto-fonts-emoji;
     #      name = "Noto Color Emoji";
     #    };
     #  };

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
    };
}
