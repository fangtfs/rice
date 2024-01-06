/* Settings while traveling to some restricted regions.
*/

{ config, lib, rice, ... }:

let
  inherit (lib) mkOption types mkForce;
  inherit (rice.lib) mkMergeIf;

  cfg = config.rice.services.traveling;

  options = {
    region = mkOption {
      type = with types; nullOr (enum [ "China" ]);
      default = null;
      description = "Travel region.";
    };
  };


in {
  options.rice.services.traveling = options;

  config = mkMergeIf [
    {
      cond = "China" == cfg.region;
      as = {
        time.timeZone = mkForce "Asia/Shanghai";
        nix.settings.substituters = mkForce [
          # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
          # "https://mirrors.ustc.edu.cn/nix-channels/store"
          "https://mirror.sjtu.edu.cn/nix-channels/store"
        ];
      };
    }
  ];
}
