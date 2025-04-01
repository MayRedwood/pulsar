{
  # config,
  # lib,
  # pkgs,
  ...
}:
{
  imports = [
    ./system.nix # Low level hardware configuration
    ./environment.nix # Higher level environment definition
    ./programs.nix # Programs and services
  ];
}
