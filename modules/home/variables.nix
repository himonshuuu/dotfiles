{...}: {
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    NIXPKGS_ALLOW_UNFREE="1";
    XCURSOR_SIZE = "10";
    HYPRCURSOR_SIZE = "10";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    GTK_THEME = "Orchis-Dark-Compact";
    XCURSOR_THEME_CORE = "Bibata-Modern-Ice";
    GTK_CURSOR_THEME = "Bibata-Modern-Ice";
    GTK_CURSOR_SIZE = "10";
    QT_QPA_PLATFORMTHEME = "gtk3";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
  };
}