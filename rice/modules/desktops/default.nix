{ config, lib, rice, ... }:

let
  librice = rice.lib;
  cfg = config.rice.desktops;

  /* Additional arguments to import submodules.

     CONTRACT: Each profile declared in this set must have options:

       - enable
  */
  args = {
    mkDesktopOptions = { name }: with lib; {
      enable = mkEnableOption "desktop environment";
    };
  };

  ## Do not enable desktop settings if no desktop environment is enabled
  enableDesktopConfig = librice.anyEnable cfg.env;

in with lib; {
  imports = with librice; callListWithArgs args (allButDefault ./.);

  options.rice.desktops = {
    /* The display server is actually selected by the display manager.
       See: https://discourse.nixos.org/t/enabling-x11-still-results-in-wayland/25362/2
    */
    enableWayland = mkEnableOption "Wayland display server" // { default = true; };
    enableOpenGL = mkEnableOption "OpenGL support" // { default = true; };

    env = {};
  };

  config = mkIf enableDesktopConfig {
    services.xserver = {
      enable = true;
      libinput.enable = true;
    };
    programs.xwayland.enable = cfg.enableWayland;
    hardware.opengl = {
      enable = cfg.enableOpenGL;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
}
