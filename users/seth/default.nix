{ pkgs, ... }:

{

  imports = [
    ./editors/emacs
  ];

  programs.git = {
    enable = true;
    userEmail = "teshpersonal@gmail.com";
    userName = "teshst";
  };

  home.stateVersion = "23.11";
}
