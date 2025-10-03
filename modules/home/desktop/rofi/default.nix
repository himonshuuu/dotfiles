{...}: {
  programs.rofi = {
    enable = true;
  };
  home.file.".config/rofi/drun.rasi" = {
    source = ./drun.rasi;
    recursive = true;
  };
}
