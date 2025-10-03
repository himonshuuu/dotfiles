{pkgs, ...}: {
  home.packages = with pkgs; [
    hyprshot
    hyprpaper
    swaynotificationcenter
    glib
    dconf
    gsettings-desktop-schemas
    hyprpolkitagent
  ];
}
