let
  project = import ./nilla.nix;
in
{
  meta = {
    nixpkgs = project.inputs.nixpkgs.result.x86_64-linux;

    specialArgs = {
      inherit project;
      inputs = builtins.mapAttrs (_: input: input.result) project.inputs;
    };
  };

  defaults = {
    imports = [
      ./modules
    ];
  };

  saturn =
    { name, ... }:
    {
      networking.hostName = name;
      deployment = {
        allowLocalDeployment = true;
      };

      imports = [
        ./hive/saturn
      ];
    };
}
