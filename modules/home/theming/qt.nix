{pkgs, ...}: {
  qt = {
    enable = true;
    platformTheme = {
      name = "gtk3";
      package = pkgs.gtk3;
    };
    style = {
      name = "Orchis-dark";
      package = pkgs.orchis-theme;
    };
  };
}
