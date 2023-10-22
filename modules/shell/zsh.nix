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

    user.packages = with pkgs; [
      zsh
      nix-zsh-completions
      bat
      eza
      fasd
      fd
      fzf
      jq
      ripgrep
      tldr
    ];

    # FIXME NixOS (need better solution)
    programs.zsh = {
      enable = true;
      # I init completion myself, because enableGlobalCompInit initializes it
      # too soon, which means commands initialized later in my config won't get
      # completion, and running compinit twice is slow.
      promptInit = "";
    };

    home.programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableVteIntegration = true;
      syntaxHighlighting.enable = true;
      autocd = false;
      dotDir = "$ZDOTDIR";
      history = {
        path = "$XDG_CACHE_HOME/zhistory";
        expireDuplicatesFirst = true;
        ignoreDups = true;
        ignoreAllDups = true;
        ignoreSpace = true;
        extended = true;
        share = true;
        size = 100000;
        save = 100000;
      };
      historySubstringSearch.enable = true;
      antidote = {
        enable = true;
        plugins = [
          "junegunn/fzf"
          "jeffreytse/zsh-vi-mode"
          "romkatv/powerlevel10k"
          "hlissner/zsh-autopair"
        ];
      };
      loginExtra = ''
       # FIXME make check for hyprland
       exec ${pkgs.hyprland}/bin/Hyprland
      '';
    };
   };
}
