{
  lib,
  pkgs,
  config,
  inputs,
  # project,
  # system,
  ...
}:
let
  cfg = config.programs.nix-index-small;
  nix-index-pkgs = inputs.nix-index-database { inherit pkgs; };
  nix-locate-bin = pkgs.writeScriptBin "nix-locate-bin" ''
    ${nix-index-pkgs.nix-index-with-small-db}/bin/nix-locate $@
  '';
  bash-handler = pkgs.writeScript "command-not-found" ''
    #!/bin/sh

    # for bash 4
    # this will be called when a command is entered
    # but not found in the user’s path + environment
    command_not_found_handle () {

      # taken from http://www.linuxjournal.com/content/bash-command-not-found
      # - do not run when inside Midnight Commander or within a Pipe
      if [ -n "''${MC_SID-}" ] || ! [ -t 1 ]; then
        >&2 echo "$1: command not found"
        return 127
      fi

      toplevel=nixpkgs # nixpkgs should always be available even in NixOS
      cmd=$1
      attrs=$(${nix-index-pkgs.nix-index-with-small-db}/bin/nix-locate --minimal --no-group --type x --type s --top-level --whole-name --at-root "/bin/$cmd")

      case $attrs in
        "")
          >&2 echo "$cmd: command not found"
          ;;
        *)
          >&2 cat <<EOF
    The program '$cmd' is currently not installed.
    You can run it once with comma: , $cmd
    Or you can make it available in an ephemeral shell with:

    EOF
          # tput bold
          while read attr; do
            >&2 echo "  nix shell $toplevel#''${attr%'.out'}"
          done <<< "$attrs"
          # tput sgr0
          ;;
      esac

      return 127 # command not found should always exit with 127
    }
  '';
  fish-wrapper = pkgs.writeScript "command-not-found" ''
    #!${pkgs.bash}/bin/bash
    source ${bash-handler}
    command_not_found_handle "$@"
  '';
in
{
  ###### interface
  options = {
    programs.nix-index-small = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable a small version of the nix-index database,
          as a replacement to command-not-found.
        '';
      };
      enableFishIntegration = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to enable fish integration for nix-index-small.
        '';
      };
      extraBins = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable additional binaries for convenience.
        '';
      };
    };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    assertions =
      let
        checkOpt = name: {
          assertion = cfg.${name} -> !config.programs.command-not-found.enable;
          message = ''
            The 'programs.command-not-found.enable' option is mutually exclusive
            with the 'programs.nix-index-small.${name}' option.
          '';
        };
      in
      [
        # (checkOpt "enableBashIntegration")
        # (checkOpt "enableZshIntegration")
        (checkOpt "enableFishIntegration")
      ];

    programs = {
      fish.interactiveShellInit = lib.mkIf cfg.enableFishIntegration ''
        function __fish_command_not_found_handler --on-event fish_command_not_found
          ${fish-wrapper} $argv
        end
      '';
    };

    environment.systemPackages = lib.mkIf cfg.extraBins (
      (with nix-index-pkgs; [
        nix-index-with-db
        comma-with-db
      ])
      ++ [
        nix-locate-bin
      ]
    );
  };
}
