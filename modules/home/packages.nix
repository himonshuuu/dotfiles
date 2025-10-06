{pkgs, ...}: {
  home.packages = with pkgs; [
    hyprshot
    hyprpaper
    swaynotificationcenter
    glib
    dconf
    gsettings-desktop-schemas
    # polkit_gnome
    mate.mate-polkit
  ];
}
