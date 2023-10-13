{pkgs, inputs, nixos-hardware, disko, vars, ... }:

{

 imports = [
   ./hardware-configuration.nix

   disko.nixosModules.disko
   ./disko-config.nix
   {
     _module.args.disks = [ "/dev/nvme0n1" ];
   }

   nixos-hardware.nixosModules.omen-16-n0005ne

   ../../hardware/efi.nix
   ../../hardware/bluetooth.nix
   ../../hardware/sound.nix

   ../../modules/graphical/hyprland
 ];

 networking = {
  hostName = "omen-laptop";
  networkmanager.enable = true;
 };

}
