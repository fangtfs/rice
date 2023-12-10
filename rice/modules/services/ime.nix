{ config, pkgs, lib, rice, ... }:

let
  librice = rice.lib;
  cfg = config.rice.services.ime;

in with lib; {
  options.rice.services.ime = {
    enabled = mkOption {
      type = with types; nullOr (enum [ "fcitx" "ibus" ]);
      default = null;
      description = "Enabled input method";
    };
  };

  config = librice.mkMergeIf [
    {
      cond = "ibus" == cfg.enabled;
      as = {
        i18n.inputMethod = {
          enabled = "ibus";
          ibus.engines = with pkgs; [
            ibus-engines.rime
          ];
        };

        environment.systemPackages = with pkgs; [
          librime
          rime-cli
          rime-data
        ];
      };
    }

    {
      cond = "fcitx" == cfg.enabled;
      as = {
        i18n.inputMethod = {
          enabled = "fcitx5";
          fcitx5.addons = with pkgs; [
            fcitx5-rime
            fcitx5-configtool
            fcitx5-chinese-addons
            fcitx5-gtk
          ];
        };

        environment.systemPackages = with pkgs; [
          librime
          rime-cli
          rime-data
        ];
      };
    }
  ];
}
