{ options, config, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
    };

    # user.openssh.authorizedKeys.keys =
    #   if config.user.name == "hlissner"
    #   then [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB71rSnjuC06Qq3NLXQJwSz7jazoB+umydddrxL6vg1a hlissner" ]
    #   else [];
  };
}
