{ pkgs, vars, ... }:

{

  imports = [
    ../../modules/core/home.nix
    ../../modules/graphical/hyprland/home.nix
  ];
  
  programs.git = {
    enable = true;
    userEmail = "teshpersonal@gmail.com";
    userName = "teshst";
  };

  home.stateVersion = "23.11";
}
