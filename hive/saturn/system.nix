{
  # config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./acer-wmi-battery
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "saturn";

    # pihole-doh.enable = true;

    nftables.enable = true;

    networkmanager = {
      enable = true;
      # wifi.backend = "iwd";
    };
  };

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";

  console = lib.mkDefault {
    font = "Lat2-Terminus16";
    keyMap = "br-abnt2";
    useXkbConfig = true;
  };

  hardware = {
    enableAllFirmware = true;
    bluetooth.enable = true;

    nvidia = {
      open = true;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        # Bus ID of the AMD GPU. You can find it using lspci, either under 3D or VGA
        amdgpuBusId = "PCI:6:0:0";
        # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  services = {
    xserver.videoDrivers = [ "nvidia" ];

    dbus.implementation = "broker";

    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      wireplumber.configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/alsa.conf" ''
          monitor.alsa.rules = [
            {
              matches = [
                {
                  # Matches all sources
                  node.name = "~alsa_input.*"
                },
                {
                  # Matches all sinks
                  node.name = "~alsa_output.*"
                }
              ]
              actions = {
                update-props = {
                  session.suspend-timeout-seconds = 0
                }
              }
            }
          ]
        '')
      ];
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

    fwupd.enable = true;
  };

  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [ dualsensectl ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older
  # NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see
  # https://nixos.org/manual/nixos/stable/#sec-upgrading for how to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make
  # to your configuration, and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
