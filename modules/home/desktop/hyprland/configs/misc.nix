{ pkgs, config, ... }: {
  misc = {
    force_default_wallpaper = 0;
    disable_hyprland_logo = true;
    font_family = "JetBrainsMono Nerd Font Regular 10";
  };
  cursor_size = 10;

  ecosystem = {
    no_update_news = true;
  };
}
