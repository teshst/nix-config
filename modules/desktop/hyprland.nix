{ options, config, lib, pkgs, hyprland, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.hyprland;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.hyprland = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wl-clipboard
      wl-clip-persist
      cliphist
      pulsemixer
      polkit_gnome
      dunst
      libnotify
      swaylock-effects
    ];

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

    systemd.user.services.dunst = {
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
      extraConfig =
      ''

      monitor=eDP-2,1920x1080@60,0x0,1
      monitor=,highrr,auto,1

      # Polkit
      exec-once=/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1

      # XDG Portals
      exec-once=$XDG_CONFIG_HOME/hypr/script/portallaunch.sh
      exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

      # Clipboard
      exec-once = wl-paste --type text --watch cliphist store #Stores only text data

      exec-once = wl-paste --type image --watch cliphist store #Stores only image data

      $mod = SUPER

      input {
        numlock_by_default=true
        follow_mouse=2;
        touchpad {
          natural_scroll=false
          middle_button_emulation=true
          disable_while_typing=true
          tap-to-click=true
        }
      }

      gestures {
        workspace_swipe=true
        workspace_swipe_fingers=3
        workspace_swipe_distance=100
      }

      animations {
        enabled=true
        bezier = myBezier,0.1,0.7,0.1,1.05
        animation=fade,1,7,default
        animation=windows,1,7,myBezier
          animation=windowsOut,1,3,default,popin 60%
          animation=windowsMove,1,7,myBezier
        }

        decoration {
          active_opacity=1.0
          inactive_opacity=0.7
        }

        general {
          border_size=3
          gaps_in=5
          gaps_out=7
          col.active_border=0x80ffffff
          col.inactive_border=0x66333333
          layout=dwindle
        }

        dwindle {
          pseudotile=false
          force_split=2
        }

        misc {
          disable_hyprland_logo=true
          disable_splash_rendering=true
          enable_swallow = true
          swallow_regex = ^(Alacritty)$
        }

        debug {
          damage_tracking = 2
        }

        # unscale XWayland
        xwayland {
          force_zero_scaling = true
        }

        windowrule = float, file_progress
        windowrule = float, confirm
        windowrule = float, dialog
        windowrule = float, download
        windowrule = float, notification
        windowrule = float, error
        windowrule = float, splash
        windowrule = float, confirmreset
        windowrule = float, title:Open File
        windowrule = float, title:branchdialog
        windowrulev2=float,class:(udiskie),title:(udiskie)
        layerrule = noanim, selection

        bindl=,switch:Lid Switch,exec,$XDG_CONFIG_HOME/hypr/script/clamshell.sh

        bindm=$mod,mouse:272,movewindow
        bindm=$mod,mouse:273,resizewindow

        bind=$mod,Return,exec,${pkgs.kitty}/bin/kitty
        bind=$mod,B,exec,${pkgs.firefox}/bin/firefox
        bind=$mod,Q,killactive,
        bind=$mod,Escape,exit,
        bind=$mod,L,exec,${pkgs.swaylock-effects}/bin/swaylock
        bind=$mod,H,togglefloating,
        bind=$mod,Space,exec,${pkgs.rofi-wayland}/bin/rofi -show drun
        bind=$mod,P,pseudo,
        bind=$mod,F,fullscreen,
        bind=$mod,R,forcerendererreload
        bind=$mod SHIFT,R,exec,${pkgs.hyprland}/bin/hyprctl reload
        bind=$mod,T,exec,emacsclient -c

        # Clipboard
        bind = SUPER, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy

        bind=$mod,left,movefocus,l
        bind=$mod,right,movefocus,r
        bind=$mod,up,movefocus,u
        bind=$mod,down,movefocus,d

        bind=$mod SHIFT,left,movewindow,l
        bind=$mod SHIFT,right,movewindow,r
        bind=$mod SHIFT,up,movewindow,u
        bind=$mod SHIFT,down,movewindow,d

        bind=ALT,1,workspace,1
        bind=ALT,2,workspace,2
        bind=ALT,3,workspace,3
        bind=ALT,4,workspace,4
        bind=ALT,5,workspace,5
        bind=ALT,6,workspace,6
        bind=ALT,7,workspace,7
        bind=ALT,8,workspace,8
        bind=ALT,9,workspace,9
        bind=ALT,0,workspace,10
        bind=ALT,right,workspace,+1
        bind=ALT,left,workspace,-1

        bind=ALTSHIFT,1,movetoworkspace,1
        bind=ALTSHIFT,2,movetoworkspace,2
        bind=ALTSHIFT,3,movetoworkspace,3
        bind=ALTSHIFT,4,movetoworkspace,4
        bind=ALTSHIFT,5,movetoworkspace,5
        bind=ALTSHIFT,6,movetoworkspace,6
        bind=ALTSHIFT,7,movetoworkspace,7
        bind=ALTSHIFT,8,movetoworkspace,8
        bind=ALTSHIFT,9,movetoworkspace,9
        bind=ALTSHIFT,0,movetoworkspace,10
        bind=ALTSHIFT,right,movetoworkspace,+1
        bind=ALTSHIFT,left,movetoworkspace,-1

        bind=CTRL,right,resizeactive,20 0
        bind=CTRL,left,resizeactive,-20 0
        bind=CTRL,up,resizeactive,0 -20
        bind=CTRL,down,resizeactive,0 20

        # Brightness
        bind=,XF86MonBrightnessDown, exec, light -U 10
        bind=,XF86MonBrightnessUp, exec, light -A 10

        # Volume
        bind =,XF86AudioRaiseVolume,exec,pulsemixer --change-volume +5
        bind =,XF86AudioLowerVolume,exec,pulsemixer --change-volume -5
        bind =,XF86AudioMute,exec,pulsemixer --toggle-mute
        '';
    };

    user.extraGroups = [ "video" "input" ];

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
