{pkgs, ...}: let
  themeName = "Orchis-dark";
  themePkg = pkgs.orchis-theme;
  iconName = "Tela-circle";
  iconPkg = pkgs.tela-circle-icon-theme;
  fontName = "JetBrains Mono 12";
  fontPkg = pkgs.jetbrains-mono;
  cursorName = "Bibata-Modern-Ice";
  cursorPkg = pkgs.bibata-cursors;

  gtkCommonFont = {
    name = fontName;
    package = fontPkg;
  };

  gtkCommonIcon = {
    name = iconName;
    package = iconPkg;
  };

  gtkCommonCursor = {
    name = cursorName;
    package = cursorPkg;
  };

  gtk2ExtraConfig = ''
    gtk-theme-name="Orchis-Dark"
    gtk-icon-theme-name="Tela-circle-dark"
    gtk-font-name="JetBrainsMonoNL Nerd Font Mono 10"
    gtk-cursor-theme-name="Bibata-Modern-Ice"
    gtk-cursor-theme-size=10
    gtk-toolbar-style=GTK_TOOLBAR_ICONS
    gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
    gtk-button-images=0
    gtk-menu-images=0
    gtk-enable-event-sounds=1
    gtk-enable-input-feedback-sounds=0
    gtk-xft-antialias=1
    gtk-xft-hinting=1
    gtk-xft-hintstyle="hintslight"
    gtk-xft-rgba="rgb"
  '';

  gtk3And4ExtraConfig = {
    gtk-application-prefer-dark-theme = true;
    gtk-theme-name = "Orchis-Dark";
    gtk-icon-theme-name = "Tela-circle-dark";
    gtk-font-name = "JetBrainsMonoNL Nerd Font Mono 10";
    gtk-cursor-theme-name = "Bibata-Modern-Ice";
    gtk-cursor-theme-size = 12;
    gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
    gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
    gtk-button-images = 0;
    gtk-menu-images = 0;
    gtk-enable-event-sounds = 1;
    gtk-enable-input-feedback-sounds = 0;
    gtk-xft-antialias = 1;
    gtk-xft-hinting = 1;
    gtk-xft-hintstyle = "hintslight";
    gtk-xft-rgba = "rgb";
  };
in {
  gtk = {
    enable = true;
    theme = {
      name = themeName;
      package = themePkg;
    };
    iconTheme = {
      name = iconName;
      package = iconPkg;
    };
    font = gtkCommonFont;
    cursorTheme = gtkCommonCursor;

    gtk2 = {
      enable = true;
      font = gtkCommonFont;
      iconTheme = gtkCommonIcon;
      extraConfig = gtk2ExtraConfig;
    };

    gtk3 = {
      enable = true;
      font = gtkCommonFont;
      iconTheme = gtkCommonIcon;
      extraConfig = gtk3And4ExtraConfig;
    };

    gtk4 = {
      enable = true;
      font = gtkCommonFont;
      iconTheme = gtkCommonIcon;
      extraConfig = gtk3And4ExtraConfig;
    };
  };
}
