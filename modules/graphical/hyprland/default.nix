{ pkgs, ... }:

{
  
  environment.systemPackages = with pkgs; [
    polkit_gnome
  ];

  xdg.portal = {
   enable = true;
   extraPortals = with pkgs; [
     xdg-desktop-portal-gtk
   ];
   wlr.enable = true;
  };

  programs.dconf.enable = true;
  programs.light.enable = true;

  security.pam.services.swaylock = {};
  security.polkit.enable = true;
  
  services.udisks2.enable = true;
  services.gnome.gnome-keyring.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager = {
   lightdm = {
    enable = true;
    greeters.gtk.enable = true;
   };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

}
