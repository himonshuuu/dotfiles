{ pkgs, lib, config, ... }:
{

  home.packages = with pkgs; [
    gnome-keyring
    hyprpaper
    gvfs
    openssh
  ];

  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];


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
