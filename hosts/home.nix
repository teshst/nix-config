{ config, lib, ... }:

with builtins;
with lib;

{

  ## Location config -- since Toronto is my 127.0.0.1
  time.timeZone = mkDefault "America/Boise";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";

}
