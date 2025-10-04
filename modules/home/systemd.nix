{ pkgs, lib, config, ... }:
{

  home.packages = with pkgs; [
    polkit_gnome
    gnome-keyring
    hyprpaper
    gvfs
    openssh
  ];

  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];

  services.polkit-gnome = {
    enable = true;
    package = pkgs.polkit_gnome;
  };

  services.gnome-keyring = {
    enable = true;
    package = pkgs.gnome-keyring;
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc= "on";
      splash = true;
      splash_offset = 1.0;
    };
  };

}
