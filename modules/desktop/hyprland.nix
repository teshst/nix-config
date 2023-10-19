{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.hyprland;
    configDir = config.dotfiles.configDir;
in {
  imports =  [
    inputs.hyprland.homeManagerModules.default
  ];

  options.modules.desktop.hyprland = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lightdm
      wl-clipboard
      wl-clip-persist
      cliphist
      dunst
      libnotify
      pulsemixer
      polkit_gnome
    ];

    services = {
      xserver = {
        enable = true;
        displayManager = {
          lightdm.enable = true;
          lightdm.greeters.mini.enable = true;
        };
      };
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
      wlr.enable = true;
    };

    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        ignore-empty-password = true;
        #image = "${wallpaper}";
        indicator = true;
        indicator-idle-visible = true;
        indicator-caps-lock = true;
        indicator-radius = 100;
        indicator-thickness = 16;
        line-uses-inside = true;
        effect-blur = "9x7";
        effect-vignette = "0.85:0.85";
      };
    };

    programs.dconf.enable = true;
    programs.light.enable = true;

    security.pam.services.swaylock = {};
    security.polkit.enable = true;

    services.udisks2.enable = true;
    security.pam.services.enableGnomeKeyring = true;

    services.udiskie.enable = true;
    services.poweralertd.enable = true;
    services.gnome-keyring.enable = true;

    systemd.user.services."dunst" = {
      enable = true;
      description = "";
      wantedBy = [ "default.target" ];
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
    };

    systemd.user.sessionVariables = {
      GDK_BACKEND="wayland";
      QT_QPA_PLATFORM="wayland";
      SDL_VIDEODRIVER="wayland";
      CLUTTER_BACKEND="wayland";
      XDG_CURRENT_DESKTOP="Hyprland";
      XDG_SESSION_TYPE="wayland";
      XDG_SESSION_DESKTOP="Hyprland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION="1";
    };


    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      recommendedEnvironment = true;
      systemdIntegration = true;
    };

    user.extraGroups = [ "video" "input" ];

    # link recursively so other modules can link files in their folders
    home.configFile = {
      "hypr" = {
        source = "${configDir}/hypr";
        recursive = true;
      };
    };

    home.file = {
      ".config/hypr/script/clamshell.sh" = {
        text = ''
          #!/bin/sh

          if grep open /proc/acpi/button/lid/LID/state; then
            hyprctl keyword monitor "eDP-2,1920x1080@60"
          else
            if [[ `hyprctl monitors | grep "Monitor" | wc -l` != 1 ]]; then
              hyprctl keyword monitor "eDP-2, disable"
            else
              ${pkgs.swaylock-effects}/bin/swaylock -f
              systemctl suspend
            fi
          fi
        '';
        executable = true;
      };
      ".config/hypr/script/portallaunch.sh" = {
        text = ''
        #!/bin/bash
        sleep 1
        killall -e xdg-desktop-portal-hyprland
        killall -e xdg-desktop-portal-wlr
        killall xdg-desktop-portal
        /usr/lib/xdg-desktop-portal-hyprland &
        sleep 2
        /usr/lib/xdg-desktop-portal &          '';
        executable = true;
      };
    };

    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];	# Install cached version so rebuild should not be required
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

  };
}
