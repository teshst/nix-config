# modules/browser/firefox.nix --- https://www.mozilla.org/en-US/firefox
#
# Oh Firefox, gateway to the interwebs, devourer of ram. Give onto me your
# infinite knowledge and shelter me from ads, but bless my $HOME with
# directories nobody needs and live long enough to turn into Chrome.

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.browsers.firefox;
in {
  options.modules.desktop.browsers.firefox = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [
        firefox-wayland
      ];

    }
  ]);
}
