{ config, pkgs, inputs, ... }:

{

  imports =  [
   inputs.hyprland.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    hyprpaper
    wl-clipboard
    wl-clip-persist
    cliphist
    pulsemixer
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    papirus-icon-theme
  ];

  gtk = {                                     # Theming
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  qt = {
    enable = true;
  };
  
  programs.swaylock = {
   enable = true;
  };

  programs.rofi = {
   enable = true;
   package = pkgs.rofi-wayland;
   extraConfig = {
     show-icons = true;
   };
  };

  programs.wlogout.enable = true;

  services.mako.enable = true;
  services.udiskie.enable = true;
  services.poweralertd.enable = true;

  xdg.enable = true;
  xdg.userDirs = {
   enable = true;
   createDirectories = true;
  };
#  xdg.mime.enable = true;
 # xdg.mimeApps = {
  # enable = true;
  #};

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
    package = pkgs.hyprland;
    xwayland.enable = true;
    recommendedEnvironment = true;
    systemdIntegration = true;
    extraConfig = import ./hyprland.nix { inherit pkgs; };
  };

}
