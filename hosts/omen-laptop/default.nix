{ inputs, ... }:

{

 imports = [
   ../home.nix
   ./hardware-configuration.nix

   inputs.disko.nixosModules.disko
   ./disko-config.nix
   {
     _module.args.disks = [ "/dev/nvme0n1" ];
   }

   inputs.nixos-hardware.nixosModules.omen-16-n0005ne

 ];

 modules = {
   desktop = {
     hyprland.enable = true;
     apps = {
       rofi.enable = true;
     };
     browsers = {
       default = "firefox";
       firefox.enable = true;
     };
     media = {
       documents.enable = true;
     };
     term = {
       default = "kitty";
       kitty.enable = true;
     };
   };
   editors = {
     default = "nvim";
     emacs = {
       enable = true;
       doom.enable = true;
     };
     nvim.enable  = true;
   };
   shell = {
     zsh.enable = true;
     git.enable = true;
     gnupg.enable = true;
   };
   services = {
     ssh.enable  = true;
   };
   theme.active = "hex";
 };

 ## Local config
 programs.ssh.startAgent = true;
 services.openssh.startWhenNeeded = true;

 networking.networkmanager.enable = true;

 time.timeZone = "America/Boise";

}
