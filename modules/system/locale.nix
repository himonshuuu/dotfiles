{...}: {
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
