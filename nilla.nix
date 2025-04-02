let
  pins = import ./npins;
  nilla = import pins.nilla;

  systems = [ "x86_64-linux" ];

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
nilla.create {
  config = {
    inputs = builtins.mapAttrs (name: pin: {
      src = pin;

      loader = loaders.${name} or { };
      settings = settings.${name} or { };
    }) pins;
  };

  includes = [ ./outputs.nix ];
}
