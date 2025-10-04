


{pkgs, config, ...}:
  let
    cursorName = "Bibata-Modern-Ice";
    cursorSize = 10;
    fontName = "JetBrainsMono Nerd Font Regular 10";
    themeName = "Orchis-Dark-Compact";
    iconName = "Tela-circle";
  in
  {
  exec-once = [
    "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 && notify-send 'Polkit agent started'"
    "waybar && notify-send 'Waybar started'"
    "hyprpaper && notify-send 'Hyprpaper started'"
    "nm-applet --indicator && notify-send 'NM applet started'"
    "blueman-applet && notify-send 'Blueman applet started'"
    "wl-paste --type text --watch cliphist store && notify-send 'Cliphist started'"
    "wl-paste --type image --watch cliphist store && notify-send 'Cliphist started'"
  ];

  exec = [
    "hyprctl setcursor ${cursorName} ${toString cursorSize} && notify-send 'Hyprland cursor set to ${cursorName} ${toString cursorSize}'"
    "gsettings set org.gnome.desktop.interface cursor-theme ${cursorName} && notify-send 'Gsettings cursor set to ${cursorName}'"
    "gsettings set org.gnome.desktop.interface cursor-size ${toString cursorSize} && notify-send 'Gsettings cursor size set to ${toString cursorSize}'"
    "gsettings set org.gnome.desktop.interface font-name ${fontName} && notify-send 'Gsettings font set to ${fontName}'"
    "gsettings set org.gnome.desktop.interface document-font-name ${fontName} && notify-send 'Gsettings document font set to ${fontName}'"
    "gsettings set org.gnome.desktop.interface monospace-font-name ${fontName} && notify-send 'Gsettings monospace font set to ${fontName}'"
    "gsettings set org.gnome.desktop.interface font-antialiasing 'rgba' && notify-send 'Gsettings font antialiasing set to rgba'"
    "gsettings set org.gnome.desktop.interface font-hinting 'full' && notify-send 'Gsettings font hinting set to full'"
    "gsettings set org.gnome.desktop.interface gtk-theme ${themeName} && notify-send 'Gsettings GTK theme set to ${themeName}'"
    "gsettings set org.gnome.desktop.interface icon-theme ${iconName} && notify-send 'Gsettings icon theme set to ${iconName}'"
    "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' && notify-send 'Gsettings color scheme set to prefer-dark'"
    "gsettings set org.gnome.desktop.interface gtk-application-prefer-dark-theme true && notify-send 'Gsettings GTK application prefer dark theme set to true'"
  ];
}
