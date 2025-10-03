{ pkgs, config, ... }: {
  misc = {
    force_default_wallpaper = -1;
  };
  cursor_size = 10;

  ecosystem = {
    no_update_news = true;
  };
}
