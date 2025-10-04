{ pkgs, ... }: {

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.gvfs = {
    enable = true;
    package = pkgs.gvfs;
  };
}
