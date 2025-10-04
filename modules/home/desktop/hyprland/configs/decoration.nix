{ pkgs, config, ... }: {
  decoration = {
    rounding = 10;

    blur = {
      enabled = true;
      size = 4;
      passes = 6;
    };
  };
}
