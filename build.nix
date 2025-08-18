let
  project = import ./nilla.nix;
  saturn = import "${project.inputs.nixpkgs.src}/nixos/lib/eval-config.nix" {
    system = "x86_64-linux";
    specialArgs = {
      inherit project;
      inputs = builtins.mapAttrs (_: input: input.result) project.inputs;
      nillapkgs = builtins.mapAttrs (_: package: package.result) project.packages;
    };
    modules = [
      {
        networking.hostName = "saturn";
        # deployment = {
        #   allowLocalDeployment = true;
        #   targetHost = null;
        # };

        imports = [
          ./nodes/saturn
          ./modules
        ];
      }
      (
        { lib, ... }:
        {
          nixpkgs.config.allowUnfree = lib.mkForce true;
        }
      )
    ];
  };
in
saturn.config.system.build.toplevel
