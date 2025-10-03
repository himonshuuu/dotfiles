{ pkgs, config, ... }: {
  decoration = {
    rounding = 10;

    blur = {
      enabled = true;
      size = 1;
      passes = 1;
    };
  };
}
