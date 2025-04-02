{ config, ... }:
let
  systems = config.modules.pulsar.defaultSystems;
  nilla-cli-package = config.inputs.nilla-cli.result.packages.nilla-cli.result.x86_64-linux;
in
{
  config = {
    shells.default = {
      inherit systems;

      shell =
        { pkgs, ... }:
        pkgs.mkShell {
          packages = with pkgs; [
            sl

            nixd
            nixfmt-rfc-style
            statix

            nilla-cli-package
            npins
            colmena
          ];
        };
    };

    packages = {
      fmt = {
        inherit systems;

        package =
          { nixfmt-tree, writeScriptBin, ... }:
          writeScriptBin "format" ''
            ${nixfmt-tree}/bin/treefmt ~/Documents/pulsar
          '';
      };

      apotris = {
        inherit systems;

        package = import ./packages/apotris;
      };
    };
  };
}
