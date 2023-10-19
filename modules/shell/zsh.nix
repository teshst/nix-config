{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.zsh;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.zsh = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.zsh;

    env = {
      ZDOTDIR   = "$XDG_CONFIG_HOME/zsh";
      ZSH_CACHE = "$XDG_CACHE_HOME/zsh";
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      enableVteIntegration = true;
      dotDir = "${configDir}/zsh";
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
        ];
      };
      shellAliases = {
        update = "sudo nixos-rebuild switch --flake ~/nix-config#omen-laptop --show-trace";
      };
      loginExtra = ''
      # FIXME make check for hyprland
      if [[ "$(tty)" == "/dev/tty1" ]] then
        exec ${pkgs.hyprland}/bin/Hyprland
      fi
      '';
    };
  };
}
