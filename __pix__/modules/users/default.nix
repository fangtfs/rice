{ config, lib, pix, ... }:

let
  libpix = pix.lib;
  cfg = config.pix.users;
  isRootUser = name: name == "root";

  /* User profile options. */
  userProfileOptions = { name, config, ... }: {
    options = with lib; {
      enable = mkEnableOption "user ${name}";

      enableNixManagement = mkEnableOption "Nix trusted user";

      description = mkOption {
        type = types.str;
        default = "";
        description = "User description.";
      };

      id = mkOption {
        type = with types; nullOr int;
        default = null;
        description = "User's UID and GID.";
      };

      groups = mkOption {
        type = with types; listOf str;
        default = [];
        description = "Groups that user belongs to.";
      };

      password = mkOption {
        type = with types; nullOr (either str path);
        default = null;
        description = ''
          This option serves three purposes.
          - If `immutable' option is disabled, the value will be used as
            `initialPassword'.
          - If `immutable' option is enabled and the value is a path, it will be
            used as `hashedPasswordFile'.
          - If `immutable' option is enabled and the value is a string, it will
            be used as `hashedPassword'.
        '';
      };
    };

    ## Disable root login by setting an invalid hashed password (if disabled).
    ## May be hardened by overriding the password outside of VC (flake template).
    config = with lib; mkIf (isRootUser name && ! config.enable) {
      password = "**DISABLED**";
    };
  };

in {
  imports = with libpix; listDir isNotDefaultNix ./.;

  /* Interface */
  options.pix.users = with lib; {
    immutable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Immutable user management.
        Note that when this is enabled the `hashedPassword' must be specified
        for each user declared within pix namespace.
      '';
    };

    ## Normal users
    profiles = mkOption {
      type = with types; attrsOf (submodule userProfileOptions);
      default = {};
      description = ''
        User profile definitions.
        NOTE: root can be defined here as well but only a few options will be
        effective to it.
      '';
    };
  };

  /* Implementation */
  config = let
    definePassword = immutable: password:
      if immutable then
        if lib.isPath password then
          { hashedPasswordFile = password; }
        else
          { hashedPassword = password; }
      else
        { initialPassword = password; };

    enabledNormalUsers = lib.filterAttrs
      (name: config: ! isRootUser name && config.enable)
      cfg.profiles;

  in {
    ## Immutable user option
    users.mutableUsers = ! cfg.immutable;

    users.users = with lib; mkMerge [
      ## Normal users
      (mapAttrs
        (name: config: {
          name = name;
          uid = config.id;
          group = name;
          extraGroups = config.groups;
          description = config.description;
          isNormalUser = true;
          isSystemUser = false;
          home = "/home/${name}";
          homeMode = "700";
          createHome = true;
        } // (definePassword cfg.immutable config.password))
        enabledNormalUsers)

      ## Root user
      {
        root = let rootCfg = cfg.profiles.root; in
               if rootCfg.enable then definePassword cfg.immutable rootCfg.password
               else { hashedPassword = rootCfg.password; };
      }
    ];

    ## User groups
    users.groups = with lib; mapAttrs'
      (name: config: nameValuePair name { gid = config.id; })
      enabledNormalUsers;

    ## Nix trusted users
    nix.settings.trusted-users = with lib; mapAttrsToList
      (name: config: name)
      (filterAttrs (name: config: config.enableNixManagement) enabledNormalUsers);

    ## Assertions
    assertions = [
      {
        assertion = libpix.anyAttrs (_: config: config.password != null) enabledNormalUsers;
        message = "Password must be provided.";
      }
      {
        assertion = let rootCfg = cfg.profiles.root; in
                    rootCfg.enable -> rootCfg.password != null;
        message = "Root password must be provided when it is enabled.";
      }
    ];
  };
}
