{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    xfce.thunar

    zip
    unzip
    p7zip
    gzip

    wget
    curl

    btop
    tree
    bat
    gvfs

    wl-clipboard

    networkmanager
    blueman
  ];

  services.gvfs = {
    enable = true;
    package = pkgs.gvfs;
  };
}
