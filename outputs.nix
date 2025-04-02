{ config, ... }:
let
  systems = [ "x86_64-linux" ];
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
