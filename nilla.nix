let
  pins = import ./npins;
  nilla = import pins.nilla;

  systems = [ "x86_64-linux" "aarch64-linux" ];

  loaders = {
    qbit = "flake";
    nixpkgs = "nixpkgs";
    nilla-cli = "nilla";
    nilla = "nilla";
    nix-index-database = "legacy";
    lix-module = "raw";
  };

  settings = {
    nixpkgs = {
      inherit systems;
      configuration = {
        allowUnfree = true;
      };
    };

    # nixpkgs-unstable = settings.nixpkgs;
  };
in
nilla.create {
  config = {
    inputs = builtins.mapAttrs (name: pin: {
      src = pin;

      loader = loaders.${name} or { };
      settings = settings.${name} or { };
    }) pins;

    modules.pulsar = { defaultSystems = systems; };
  };

  includes = [ ./nilla ];
}
