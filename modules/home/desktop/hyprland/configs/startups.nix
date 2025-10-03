{pkgs, config, ...}: {
  exec-once = [
    "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 && notify-send 'Polkit agent started'"
    "waybar && notify-send 'Waybar started'"
    "hyprpaper && notify-send 'Hyprpaper started'"
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &"
    "nm-applet --indicator && notify-send 'NM applet started'"
    "blueman-applet && notify-send 'Blueman applet started'"
    "wl-paste --type text --watch cliphist store && notify-send 'Cliphist started'"
    "wl-paste --type image --watch cliphist store && notify-send 'Cliphist started'"
  ];

  exec = [
    "hyprctl setcursor Bibata-Modern-Ice 10 && notify-send 'Hyprland cursor set to Bibata-Modern-Ice 10'"
    "gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice' && notify-send 'Gsettings cursor set to Bibata-Modern-Ice'"
    "gsettings set org.gnome.desktop.interface cursor-size 10 && notify-send 'Gsettings cursor size set to 10'"
    "gsettings set org.gnome.desktop.interface font-name 'JetBrainsMono Nerd Font 10' && notify-send 'Gsettings font set to JetBrainsMono Nerd Font 10'"
    "gsettings set org.gnome.desktop.interface document-font-name 'JetBrainsMono Nerd Font 10' && notify-send 'Gsettings document font set to JetBrainsMono Nerd Font 10'"
    "gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 10' && notify-send 'Gsettings monospace font set to JetBrainsMono Nerd Font 10'"
    "gsettings set org.gnome.desktop.interface font-antialiasing 'rgba' && notify-send 'Gsettings font antialiasing set to rgba'"
    "gsettings set org.gnome.desktop.interface font-hinting 'full' && notify-send 'Gsettings font hinting set to full'"
    "gsettings set org.gnome.desktop.interface gtk-theme 'Orchis-Dark-Compact' && notify-send 'Gsettings GTK theme set to Orchis-Dark-Compact'"
    "gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-blue-dark' && notify-send 'Gsettings icon theme set to Tela-circle-blue-dark'"
    "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' && notify-send 'Gsettings color scheme set to prefer-dark'"
    "gsettings set org.gnome.desktop.interface gtk-application-prefer-dark-theme true && notify-send 'Gsettings GTK application prefer dark theme set to true'"
  ];
}
