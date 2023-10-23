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

    programs.zsh = {
      enable = true;
      histSize = 10000;
      histFile = ".config/zsh/history";
    };

    home.programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableVteIntegration = true;
      syntaxHighlighting.enable = true;
      dotDir = ".config/zsh";
      plugins =
      [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = "${configDir}/zsh/p10k-config";
          file = "p10k.zsh";
        }
      ];
  		oh-my-zsh = {
				enable = true;
				plugins = [ "git" "sudo" ];
			};
      loginExtra = ''
       # FIXME make check for hyprland
       exec ${pkgs.hyprland}/bin/Hyprland
      '';
    };
   };
}
