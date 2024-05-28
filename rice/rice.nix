{ nixpkgs, flake }:

let
  rice = self: {
    args = {
      inherit nixpkgs flake;
      rice = self; # Self reference
      librice = self.lib;
      dirrice = self.dirs;
    };

    lib = import ./lib (self.args // {
      ## Blend with flake inputs
      specialArgs = self.args.flake.inputs // self.args;
    });

    dirs = with self.dirs;
      let withTopLevel = p: "${topLevel}/${p}";
      in {
        topLevel = builtins.path { path = ./.; }; # Explicit copy
        devshells = withTopLevel "devshells";
        dotfiles = withTopLevel "dotfiles";
        instances = withTopLevel "instances";
        modules = withTopLevel "modules";
        overlays = withTopLevel "overlays";
        packages = withTopLevel "packages";
        templates = withTopLevel "templates";
      };

    override = args: let newRice = rice (newRice // args) // args; in newRice;
  };

  ## Make it easier to test so that we don't have to rely on the fix function from nixpkgs
  fix = f: let x = f x; in x;

in fix rice
