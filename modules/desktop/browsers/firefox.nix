# modules/browser/firefox.nix --- https://www.mozilla.org/en-US/firefox
#
# Oh Firefox, gateway to the interwebs, devourer of ram. Give onto me your
# infinite knowledge and shelter me from ads, but bless my $HOME with
# directories nobody needs and live long enough to turn into Chrome.

{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.browsers.firefox;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.browsers.firefox = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [
        firefox-wayland
      ];

      home.programs.firefox = {
        enable = true;
        package = pkgs.firefox-wayland;
        profiles = {
          default = {
            name = "Default";
            id = 0;
            search = {
              default = "Google";
            };
            #bookmarks = import "${configDir}/firefox/bookmarks.html";
            extensions = with config.nur.repos.rycee.firefox-addons; [
              ublock-origin
              bitwarden
            ];
            settings = {
              "browser.startup.homepage" = "https://www.google.com";

              # Enable HTTPS-Only Mode
              "dom.security.https_only_mode" = true;
              "dom.security.https_only_mode_ever_enabled" = true;

              # Privacy settings
              "privacy.donottrackheader.enabled" = true;
              "privacy.trackingprotection.enabled" = true;
              "privacy.trackingprotection.socialtracking.enabled" = true;
              "privacy.partition.network_state.ocsp_cache" = true;

                # Disable all sorts of telemetry
              "browser.newtabpage.activity-stream.feeds.telemetry" = false;
              "browser.newtabpage.activity-stream.telemetry" = false;
              "browser.ping-centre.telemetry" = false;
              "toolkit.telemetry.archive.enabled" = false;
              "toolkit.telemetry.bhrPing.enabled" = false;
              "toolkit.telemetry.enabled" = false;
              "toolkit.telemetry.firstShutdownPing.enabled" = false;
              "toolkit.telemetry.hybridContent.enabled" = false;
              "toolkit.telemetry.newProfilePing.enabled" = false;
              "toolkit.telemetry.reportingpolicy.firstRun" = false;
              "toolkit.telemetry.shutdownPingSender.enabled" = false;
              "toolkit.telemetry.unified" = false;
              "toolkit.telemetry.updatePing.enabled" = false;

              # As well as Firefox 'experiments'
              "experiments.activeExperiment" = false;
              "experiments.enabled" = false;
              "experiments.supported" = false;
              "network.allow-experiments" = false;

              # Disable Pocket Integration
              "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
              "extensions.pocket.enabled" = false;
              "extensions.pocket.api" = "";
              "extensions.pocket.oAuthConsumerKey" = "";
              "extensions.pocket.showHome" = false;
              "extensions.pocket.site" = "";


            };
          };
        };
      };

    }
  ]);
}
