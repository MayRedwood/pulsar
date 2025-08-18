{
  # config,
  lib,
  pkgs,
  project,
  inputs,
  ...
}:
let
  nilla-cli-package = inputs.nilla-cli.packages.nilla-cli.result.${pkgs.system};
in
{
  # imports = [ (import "${inputs.lix-module}/module.nix" { lix = null; }) ];

  nix = {
    package = pkgs.lixPackageSets.latest.lix;
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
    # nixPath = lib.mkForce [ "nixpkgs=flake:nixpkgs" ];
    # channel.enable = false;
  };
  nixpkgs.flake.source = lib.mkForce project.inputs.nixpkgs.src;

  users.users.moon = {
    isNormalUser = true;
    uid = 1000;
    description = "Munds";
    extraGroups = [
      "networkmanager"
      "wheel"
      "keyd"
      "transmission"
      "qbittorrent"
      "pipewire"
      "input"
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
      font-awesome
      adwaita-fonts
    ];
  };

  services = {
    # playerctld.enable = true;
    # displayManager.sddm = {
    #   enable = true;
    #   wayland.enable = true;
    # };
    # desktopManager.plasma6.enable = true;
    # desktopManager.gnome.enable = true;
    # displayManager.gdm.enable = true;
    displayManager.ly = {
      enable = true;
      x11Support = false;
      settings = {
        animation = "colormix";
        hide_version_string = true;
        hide_key_hints = true;
        # full_color = false;
        # bigclock = "en";
        # colormix_col1 = "0x00FF0030";
        # colormix_col2 = "0x000030FF";
        # colormix_col1 = "0x0005";
        # colormix_col2 = "0x0006";
        # colormix_col3 = "0x0001";
      };
    };

    gnome = {
      games.enable = true;
    #   core-developer-tools.enable = true;
    };

    gvfs.enable = true;

    flatpak.enable = true;

    whoogle-search = {
      enable = true;
      extraEnv = {
        WHOOGLE_CONFIG_LANGUAGE = "lang_en";
        WHOOGLE_CONFIG_SEARCH_LANGUAGE = "lang_en";
      };
    };
  };

  programs = {
    niri.enable = true;
    
    command-not-found.enable = false;
    nix-index-small = {
      enable = true;
      extraBins = true;
    };

    # dconf.profiles.user.databases = [
    #   {
    #     # lockAll = true;
    #     settings = {
    #       "org/gnome/shell" = {
    #         favorite-apps = [
    #           "vesktop.desktop"
    #           "app.zen_browser.zen.desktop"
    #           "com.mitchellh.ghostty.desktop"
    #           "org.gnome.Decibels.desktop"
    #           "org.gnome.Nautilus.desktop"
    #           "org.gnome.Software.desktop"
    #         ];
    #         enabled-extensions = [
    #           "clipboard-indicator@tudmotu.com"
    #           "lockkeys@vaina.lt"
    #           "newworkspaceshortcut@barnix.io"
    #           "user-theme@gnome-shell-extensions.gcampax.github.com"
    #           "azwallpaper@azwallpaper.gitlab.com"
    #         ];
    #       };
    #       "org/gnome/shell/extensions/clipboard-indicator" = {
    #         move-item-first = true;
    #         paste-button = false;
    #         toggle-menu = [ "<Super>c" ];
    #       };
    #       "org/gnome/shell/extensions/lock-keys" = {
    #         style = "show-hide-capslock";
    #       };
    #       "org/gnome/shell/extensions/newworkspaceshortcut" = {
    #         move-window-to-right-workspace = [ "<Super><Shift>K" ];
    #         move-window-to-left-workspace = [ "<Super><Shift>J" ];
    #         empty-workspace-right = [ "<Super>K" ];
    #         empty-workspace-left = [ "<Super>J" ];
    #         workspace-right = [ "<Super><Control>K" ];
    #         workspace-left = [ "<Super><Control>J" ];
    #         move-workspace-triggers-overview = false;
    #       };
    #       "org/gnome/shell/extensions/azwallpaper" = {
    #         slideshow-directory = "org/gnome/shell/extensions/azwallpaper";
    #         slideshow-timer-remaining = lib.gvariant.mkUint32 3600;
    #       };
    #       "org/gnome/mutter" = {
    #         workspaces-only-on-primary = false;
    #       };
    #       "org/gnome/desktop/search-providers" = {
    #         sort-order = [
    #           "org.gnome.Settings.desktop"
    #           "org.gnome.Calculator.desktop"
    #           "org.gnome.Characters.desktop"
    #           "org.gnome.Calendar.desktop"
    #           "org.gnome.Nautilus.desktop"
    #           "org.gnome.Boxes.desktop"
    #           "org.gnome.clocks.desktop"
    #           "org.gnome.Contacts.desktop"
    #         ];
    #       };
    #       "org/gnome/desktop/peripherals/mouse" = {
    #         accel-profile = "flat";
    #       };
    #       "org/gnome/desktop/peripherals/keyboard" = {
    #         delay = lib.gvariant.mkUint32 300;
    #         repeat-interval = lib.gvariant.mkUint32 25;
    #       };
    #       "org/gnome/desktop/input-sources" = {
    #         sources = [
    #           (lib.gvariant.mkTuple [
    #             "xkb"
    #             "br+nodeadkeys"
    #           ])
    #           (lib.gvariant.mkTuple [
    #             "xkb"
    #             "br"
    #           ])
    #         ];
    #         xkb-options = [
    #           "terminate:ctrl_alt_bksp"
    #           "caps:swapescape"
    #         ];
    #       };
    #       "org/gnome/desktop/a11y/keyboard" = {
    #         togglekeys-enable = true;
    #       };
    #       "org/gnome/desktop/calendar" = {
    #         show-weekdate = true;
    #       };
    #       "org/gnome/desktop/interface" = {
    #         clock-show-seconds = true;
    #         clock-show-date = false;
    #         font-hinting = "none";
    #       };
    #       "org/gnome/desktop/screen-time-limits" = {
    #         daily-limit-enabled = true;
    #       };
    #       "org/gnome/settings-daemon/plugins/color" = {
    #         night-light-schedule-automatic = false;
    #       };
    #       "org/gnome/settings-daemon/plugins/media-keys" = {
    #         screensaver = [ "" ];
    #       };
    #       "org/gnome/desktop/wm/keybindings" = {
    #         minimize = [ "" ];
    #         switch-to-workspace-left = [ "<Super>h" ];
    #         switch-to-workspace-right = [ "<Super>l" ];
    #         move-to-workspace-left = [ "<Shift><Super>h" ];
    #         move-to-workspace-right = [ "<Shift><Super>l" ];
    #       };
    #     };
    #   }
    # ];
  };

  virtualisation.podman.enable = true;

  environment = {
    # etc."containers/systemd/whoogle.container".source = ./system-containers/whoogle.container;
    # etc."containers/systemd/pihole.container".source = ./system-containers/pihole.container;

    etc."security/limits.d/95-pipewire.conf".text = ''
      # Default limits for users of pipewire
      @pipewire - rtprio 95
      @pipewire - nice -19
      @pipewire - memlock 4194304
    '';

    sessionVariables = {
      # NAUTILUS_4_EXTENSION_DIR = lib.mkForce "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
    };
    variables = {
      EDITOR = "hx";
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
      (writeShellApplication {
        name = "nia";

        runtimeInputs = [
          just
          bash
          nushell
          lixPackageSets.latest.colmena
          nvd
          npins
          nilla-cli-package
        ];

        text = ''
          just --justfile /home/moon/Documents/pulsar/justfile "$@"
        '';
      })
      nilla-cli-package
      npins
      lixPackageSets.latest.colmena

      nvd
      nix-output-monitor
      nix-tree
      # nix-melt
      # nix-inspect
      nix-du
      nix-btm
      lixPackageSets.latest.nix-eval-jobs
      # nix-eval-jobs
      just

      wget
      prettyping
      pv
      zip
      unzip
      chafa

      adw-gtk3
      nautilus
      adwaita-icon-theme
      adwaita-icon-theme-legacy
      adwaita-fonts
      # gnomeExtensions.clipboard-indicator
      # gnomeExtensions.lock-keys
      # gnomeExtensions.new-workspace-shortcut
      # gnomeExtensions.user-themes
      # gnomeExtensions.wallpaper-slideshow
      # gnomeExtensions.undecorate
      # gnomeExtensions.caffeine
      xorg.xprop
      gradia

      swayidle
      brightnessctl
      hyprlock

      waybar
      fuzzel
      swww
      mako
      clipse
      # playerctl
      pavucontrol
      networkmanagerapplet
      bluetui
      xwayland-satellite
    ];
  };

  # Set sudo-rs as our default sudo provider
  security = {
    # soteria.enable = true;
    sudo.enable = false;
    sudo-rs = {
      enable = true;
      execWheelOnly = true;
    };
  };
}
