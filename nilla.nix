let
  pins = import ./npins;
  nilla = import pins.nilla;
in
nilla.create (
  { config }:
  let
    systems = [ "x86_64-linux" ];

    nilla-cli-package = config.inputs.nilla-cli.result.packages.nilla-cli.result.x86_64-linux;

    loaders = {
      qbit = "flake";
      nixpkgs = "nixpkgs";
      nilla-cli = "nilla";
      nilla = "nilla";
      nix-index-database = "legacy";
    };

    settings = {
      nixpkgs = {
        inherit systems;
        configuration = {
          allowUnfree = true;
        };
      };

      nixpkgs-unstable = settings.nixpkgs;
    };
  in
  {
    config = {
      inputs = builtins.mapAttrs (name: pin: {
        src = pin;

        loader = loaders.${name} or { };
        settings = settings.${name} or { };
      }) pins;

      shells.default = {
        inherit systems;

        shell =
          { pkgs, ... }:
          pkgs.mkShell {
            packages = with pkgs; [
              sl
              npins
              nixd
              statix
              nixfmt-rfc-style
              nilla-cli-package
              colmena
            ];
          };
      };

      packages.fmt = {
        inherit systems;

        package =
          { nixfmt-tree, writeScriptBin, ... }:
          writeScriptBin "format" ''
            ${nixfmt-tree}/bin/treefmt ~/Documents/nilla-test
          '';
      };
    };
  }
)
