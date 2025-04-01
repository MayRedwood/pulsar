{
  # config,
  # lib,
  # system,
  inputs,
  pkgs,
  ...
}:
{
  nix = {
    package = pkgs.lix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # Cachix configurations
      # builders-use-substitutes = true;
      extra-substituters = [
        # "https://hyprland.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        # "https://helix.cachix.org"
        # "https://anyrun.cachix.org"
        # "https://viperml.cachix.org"
        "https://nix-gaming.cachix.org"
        "https://cache.lix.systems"
      ];
      trusted-public-keys = [
        # "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        # "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        # "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        # "viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      # plugin-files = "${
      #   pkgs.nix-plugin-pijul.override { nix = config.nix.package; }
      # }/lib/nix/plugins/pijul.so";
    };
  };

  users.users.moon = {
    isNormalUser = true;
    uid = 1000;
    description = "May Munds";
    extraGroups = [
      "networkmanager"
      "wheel"
      "keyd"
      "transmission"
      "qbittorrent"
    ];
    shell = pkgs.bash;
    packages = with pkgs; [
      hello
    ];
  };
  # documentation.man.generateCaches = false; # Disable the fish generation

  fonts = {
    fontconfig = {
      hinting.enable = false;
      subpixel.lcdfilter = "none";
    };
    packages = with pkgs; [
      atkinson-hyperlegible-next
      atkinson-hyperlegible-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      maple-mono.truetype
      nerd-fonts.space-mono
    ];
  };

  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    desktopManager.plasma6.enable = true;

    flatpak.enable = true;
  };

  programs = {
    command-not-found.enable = false;
    nix-index-small = {
      enable = true;
      extraBins = true;
    };

    nh = {
      enable = true;
      flake = "/home/moon/Documents/flake";
    };
  };

  virtualisation.podman.enable = true;

  environment = {
    etc."containers/systemd/whoogle.container".source = ./system-containers/whoogle.container;

    sessionVariables = {
      # NOTE: SYSTEM CONFIG PATH. Please refer to this when needed.
      # FLAKE = "/home/moon/Documents/flake";
      # NAUTILUS_4_EXTENSION_DIR = lib.mkForce "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
    };
    variables = {
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
      # PIX_DEFSHELL = "fish";
      # man colors
      MANPAGER = "less -R --use-color -Dd+m -Du+b";
      MANROFFOPT = "-P -c";
      # GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
      # FIXME: This is due to an upstream bug with Nvidia drivers.
      # GSK_RENDERER = "ngl";
      COMMA_PICKER = "fzf";
    };
    # pathsToLink = [ "/share/nautilus-python/extensions" ];

    systemPackages = with pkgs; [
      nvd
      nix-output-monitor
      nix-tree
      nix-melt
      nix-inspect
      nix-du
      nix-btm
      just

      wget
      prettyping
      pv
      zip
      unzip
      chafa
    ];
  };

  # Set sudo-rs as our default sudo provider
  security = {
    sudo.enable = false;
    sudo-rs = {
      enable = true;
      execWheelOnly = true;
    };
  };
}
