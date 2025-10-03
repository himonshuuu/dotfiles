{
  ...
}: {
  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 80 443];
    allowedUDPPorts = [];
  };
}
