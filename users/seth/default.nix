{ pkgs, ... }:

{

  imports = [
    ./editors/emacs
    ../../modules/graphical/hyprland/home.nix
  ];
  
  xsession.enable = true;

  programs.git = {
    enable = true;
    userEmail = "teshpersonal@gmail.com";
    userName = "teshst";
  };

  home.stateVersion = "23.11";
}
