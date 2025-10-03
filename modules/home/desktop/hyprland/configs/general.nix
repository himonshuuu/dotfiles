{ pkgs, config, ... }: {
  general = {
    gaps_in = 5;
    gaps_out = 10;
    border_size = 0;

    layout = "dwindle";

    allow_tearing = false;
  };
}
