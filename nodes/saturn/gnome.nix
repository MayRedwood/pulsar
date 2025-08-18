{
  # config,
  lib,
  pkgs,
  # project,
  # inputs,
  ...
}:
{
  services = {
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    gnome = {
      games.enable = true;
      core-developer-tools.enable = true;
    };
  };

  programs = {
    dconf.profiles.user.databases = [
      {
        # lockAll = true;
        settings = {
          "org/gnome/shell" = {
            favorite-apps = [
              "vesktop.desktop"
              "app.zen_browser.zen.desktop"
              "com.mitchellh.ghostty.desktop"
              "org.gnome.Decibels.desktop"
              "org.gnome.Nautilus.desktop"
              "org.gnome.Software.desktop"
            ];
            enabled-extensions = [
              "clipboard-indicator@tudmotu.com"
              "lockkeys@vaina.lt"
              "newworkspaceshortcut@barnix.io"
              "user-theme@gnome-shell-extensions.gcampax.github.com"
              "azwallpaper@azwallpaper.gitlab.com"
            ];
          };
          "org/gnome/shell/extensions/clipboard-indicator" = {
            move-item-first = true;
            paste-button = false;
            toggle-menu = [ "<Super>c" ];
          };
          "org/gnome/shell/extensions/lock-keys" = {
            style = "show-hide-capslock";
          };
          "org/gnome/shell/extensions/newworkspaceshortcut" = {
            move-window-to-right-workspace = [ "<Super><Shift>K" ];
            move-window-to-left-workspace = [ "<Super><Shift>J" ];
            empty-workspace-right = [ "<Super>K" ];
            empty-workspace-left = [ "<Super>J" ];
            workspace-right = [ "<Super><Control>K" ];
            workspace-left = [ "<Super><Control>J" ];
            move-workspace-triggers-overview = false;
          };
          "org/gnome/shell/extensions/azwallpaper" = {
            slideshow-directory = "org/gnome/shell/extensions/azwallpaper";
            slideshow-timer-remaining = lib.gvariant.mkUint32 3600;
          };
          "org/gnome/mutter" = {
            workspaces-only-on-primary = false;
          };
          "org/gnome/desktop/search-providers" = {
            sort-order = [
              "org.gnome.Settings.desktop"
              "org.gnome.Calculator.desktop"
              "org.gnome.Characters.desktop"
              "org.gnome.Calendar.desktop"
              "org.gnome.Nautilus.desktop"
              "org.gnome.Boxes.desktop"
              "org.gnome.clocks.desktop"
              "org.gnome.Contacts.desktop"
            ];
          };
          "org/gnome/desktop/peripherals/mouse" = {
            accel-profile = "flat";
          };
          "org/gnome/desktop/peripherals/keyboard" = {
            delay = lib.gvariant.mkUint32 300;
            repeat-interval = lib.gvariant.mkUint32 25;
          };
          "org/gnome/desktop/input-sources" = {
            sources = [
              (lib.gvariant.mkTuple [
                "xkb"
                "br+nodeadkeys"
              ])
              (lib.gvariant.mkTuple [
                "xkb"
                "br"
              ])
            ];
            xkb-options = [
              "terminate:ctrl_alt_bksp"
              "caps:swapescape"
            ];
          };
          "org/gnome/desktop/a11y/keyboard" = {
            togglekeys-enable = true;
          };
          "org/gnome/desktop/calendar" = {
            show-weekdate = true;
          };
          "org/gnome/desktop/interface" = {
            clock-show-seconds = true;
            clock-show-date = false;
            font-hinting = "none";
          };
          "org/gnome/desktop/screen-time-limits" = {
            daily-limit-enabled = true;
          };
          "org/gnome/settings-daemon/plugins/color" = {
            night-light-schedule-automatic = false;
          };
          "org/gnome/settings-daemon/plugins/media-keys" = {
            screensaver = [ "" ];
          };
          "org/gnome/desktop/wm/keybindings" = {
            minimize = [ "" ];
            switch-to-workspace-left = [ "<Super>h" ];
            switch-to-workspace-right = [ "<Super>l" ];
            move-to-workspace-left = [ "<Shift><Super>h" ];
            move-to-workspace-right = [ "<Shift><Super>l" ];
          };
        };
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    adwaita-icon-theme-legacy
    adwaita-fonts
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.lock-keys
    gnomeExtensions.new-workspace-shortcut
    gnomeExtensions.user-themes
    gnomeExtensions.wallpaper-slideshow
    gnomeExtensions.undecorate
    gnomeExtensions.caffeine
    xorg.xprop
    gradia
  ];
}
