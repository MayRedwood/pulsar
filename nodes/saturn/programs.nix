{
  # config,
  lib,
  pkgs,
  # system,
  # project,
  inputs,
  # nillapkgs,
  ...
}:
{
  programs = {
    fish.enable = true;
    zsh.enable = true;

    starship.enable = true;
    git.enable = true;
    direnv.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };

  services = {
    usermpd = {
      enable = true;
      dataDir = "/home/moon/.local/share/mpd";
      musicDirectory = "/home/moon/Music/";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "SaturnPipewire"
        }
      '';
      mpd-mpris = true;
    };

    # transmission = {
    #   enable = true;
    #   package = pkgs.transmission_4;
    #   openPeerPorts = true;
    #   webHome = pkgs.flood-for-transmission;
    # };
    qbittorrent = {
      enable = true;
      package = inputs.qbit.legacyPackages.${pkgs.system}.qbittorrent-nox;
      serverConfig = {
        LegalNotice.Accepted = true;
        Preferences.WebUI = {
          AlternativeUIEnabled = true;
          RootFolder = "${pkgs.vuetorrent}/share/vuetorrent";
          LocalHostAuth = false;
        };
      };
      openFirewall = true;
      webuiPort = 8080;
      torrentingPort = 14104;
    };
  };

  imports = [
    ./neovim.nix
    ./media.nix
    ./glance.nix
    "${inputs.qbit}/nixos/modules/services/torrent/qbittorrent.nix"
  ];

  environment.systemPackages =
    (with pkgs; [
      vim
      # emacs
      helix
      # nixd
      # nixfmt-rfc-style
      # statix
      lazygit
      ghostty

      cargo
      rustc
      # markdown-oxide
      marksman
      dprint
      libreoffice
      obsidian
      vlc

      wl-clipboard
      bat
      bat-extras.batman
      trashy
      gh
      glab
      fzf
      fd
      ripgrep
      zoxide
      eza
      tealdeer
      btop
      nitch
      killall
      nushell
      cmatrix
      cbonsai
      pipes-rs
      zk

      fortune
      cowsay
      blahaj
      gay

      mpc-cli
      rmpc

      vesktop
      krita

      steam-run

      sm64coopdx
      ringracers
      # nova.apotris
    ])
    ++ [
      # inputs.ki-editor.packages.${system}.default
      # nillapkgs.apotris.${pkgs.system}

      (pkgs.vscode.fhsWithPackages (
        pkgs: with pkgs; [
          nixfmt-rfc-style
          statix
          nixd
        ]
      ))

      (
        let
          base = pkgs.appimageTools.defaultFhsEnvArgs;
        in
        pkgs.buildFHSEnv (
          base
          // {
            name = "defhs";
            targetPkgs =
              pkgs:
              (base.targetPkgs pkgs)
              ++ (with pkgs; [
                pkg-config
                cmake
                libtool
                ncurses
                pkg-config
                zlib
                gcc
                gnumake
                curl
                openssl

                (poetry.withPlugins (
                  ps: with ps; [
                    poetry-plugin-shell
                  ]
                ))
                # poetryPlugins.poetry-plugin-shell
              ]);
            profile = "export FHS=1";
            runScript = "fish";
            extraOutputsToInstall = [ "dev" ];
          }
        )
      )
    ];
}
