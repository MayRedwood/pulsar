{ lib, pkgs, ... }:
{
  services = {
    sonarr = {
      enable = true;
      # group = "qbittorrent";
      user = "moon";
    };

    radarr = {
      enable = true;
      # group = "qbittorrent";
      user = "moon";
    };

    prowlarr = {
      enable = true;
      # user = "moon";
    };

    jellyfin = {
      enable = true;
      user = "moon";
    };
  };

  # Configure CPU usage limits on these bad boys
  systemd.services = {
    sonarr.serviceConfig = {
      CPUWeight = 3;
      CPUQuota = "5%";
      # IOWeight = 1;
    };
    radarr.serviceConfig = {
      CPUWeight = 3;
      CPUQuota = "5%";
      # IOWeight = 1;
    };
    # sonarr.wantedBy = lib.mkForce [ ];
    # radarr.wantedBy = lib.mkForce [ ];
    prowlarr = {
      # wantedBy = lib.mkForce [ ];
      serviceConfig = {
        # Also run prowlarr as the user
        DynamicUser = lib.mkForce false;
        User = "moon";
        CPUWeight = 3;
        CPUQuota = "5%";
        # IOWeight = 1;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg

    jellyfin-media-player

    recyclarr
  ];
}
