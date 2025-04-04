{ config, ... }:
let
  systems = config.modules.pulsar.defaultSystems;
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
