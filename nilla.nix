let
  pins = import ./npins;
  nilla = import pins.nilla;

  # systems = [
  #   "x86_64-linux"
  #   "aarch64-linux"
  # ];

  # loaders = {
  #   nixpkgs = "nixpkgs";
  #   nilla-cli = "nilla";
  #   nilla = "nilla";
  #   nix-index-database = "legacy";
  #   lix-module = "raw";
  #   ignis = "flake";
  #   flake-compat = "legacy";
  # };

  # settings = {
  #   nixpkgs = {
  #     inherit systems;
  #     configuration = {
  #       allowUnfree = true;
  #       # allowBroken = true;
  #     };
  #   };

  #   ignis = {};

  #   # nixpkgs-unstable = settings.nixpkgs;
  # };
in
nilla.create {
  # config = {
  #   inputs = builtins.mapAttrs (name: pin: {
  #     src = pin;

  #     loader = loaders.${name} or { };
  #     settings = settings.${name} or { };
  #   }) pins;

  #   modules.pulsar = {
  #     defaultSystems = systems;
  #   };
  # };

  includes = [ ./nilla ];
}
