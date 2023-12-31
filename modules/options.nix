{ config, options, lib, home-manager, inputs, ... }:

with lib;
with lib.my;
{
  options = with types; {
    user = mkOpt attrs {};

    dotfiles = {
      dir = mkOpt path
        (removePrefix "/mnt"
          (findFirst pathExists (toString ../.) [
            "/mnt/etc/nix-config"
            "/etc/nix-config"
            "/home/seth/nix-config"
          ]));
      binDir     = mkOpt path "${config.dotfiles.dir}/bin";
      configDir  = mkOpt path "${config.dotfiles.dir}/config";
      modulesDir = mkOpt path "${config.dotfiles.dir}/modules";
      themeDir = mkOpt path "${config.dotfiles.dir}/theme";
    };

    home = {
      file       = mkOpt' attrs {} "Files to place directly in $HOME";
      configFile = mkOpt' attrs {} "Files to place in $XDG_CONFIG_HOME";
      dataFile   = mkOpt' attrs {} "Files to place in $XDG_DATA_HOME";
      programs = mkOpt' attrs {} "Access to home manager programs";
      services =  mkOpt' attrs {} "Access to home manager services";
      systemd =  mkOpt' attrs {} "Access to home manager systemd";
      wayland =  mkOpt' attrs {} "Access to home manager wayland";
    };

    env = mkOption {
      type = attrsOf (oneOf [ str path (listOf (either str path)) ]);
      apply = mapAttrs
        (n: v: if isList v
               then concatMapStringsSep ":" (x: toString x) v
               else (toString v));
      default = {};
      description = "TODO";
    };
  };

  config = {
    user =
      let user = builtins.getEnv "USER";
          name = if elem user [ "" "root" ] then "seth" else user;
      in {
        inherit name;
        description = "The primary user account";
        extraGroups = [ "wheel" ];
        isNormalUser = true;
        home = "/home/${name}";
        group = "users";
        uid = 1000;
      };

    # Install user packages to /etc/profiles instead. Necessary for
    # nixos-rebuild build-vm to work.
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      # I only need a subset of home-manager's capabilities. That is, access to
      # its home.file, home.xdg.configFile and home.xdg.dataFile so I can deploy
      # files easily to my $HOME, but 'home-manager.users.hlissner.home.file.*'
      # is much too long and harder to maintain, so I've made aliases in:
      #
      #   home.file        ->  home-manager.users.seth.home.file
      #   home.configFile  ->  home-manager.users.seth.home.xdg.configFile
      #   home.dataFile    ->  home-manager.users.seth.home.xdg.dataFile
      users.${config.user.name} =  {
        programs = mkAliasDefinitions options.home.programs;
        services = mkAliasDefinitions options.home.services;
        systemd = mkAliasDefinitions options.home.systemd;
        wayland = mkAliasDefinitions options.home.wayland;

        imports = with inputs; [
          stylix.homeManagerModules.stylix
          # FIXME: remove when https://github.com/danth/stylix/issues/180 is fixed
          { stylix.targets.xfce.enable = false; }
        ];

        home = {
          file = mkAliasDefinitions options.home.file;
          # Necessary for home-manager to work with flakes, otherwise it will
          # look for a nixpkgs channel.
          stateVersion = config.system.stateVersion;
        };
        xdg = {
          configFile = mkAliasDefinitions options.home.configFile;
          dataFile   = mkAliasDefinitions options.home.dataFile;
        };
      };
    };

    users.users.${config.user.name} = mkAliasDefinitions options.user;

    nix.settings = let users = [ "root" config.user.name ]; in {
      trusted-users = users;
      allowed-users = users;
    };

    # must already begin with pre-existing PATH. Also, can't use binDir here,
    # because it contains a nix store path.
    env.PATH = [ "$DOTFILES_BIN" "$XDG_BIN_HOME" "$PATH" ];

    environment.extraInit =
      concatStringsSep "\n"
        (mapAttrsToList (n: v: "export ${n}=\"${v}\"") config.env);
  };
}
