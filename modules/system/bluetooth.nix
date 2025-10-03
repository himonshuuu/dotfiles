{...}: {
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        AutoEnable = true;
      };
      Headset = {
        AutoConnect = true;
      };
    };
  };
}
