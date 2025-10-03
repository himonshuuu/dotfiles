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

    wl-clipboard

    networkmanager
    blueman
  ];
}
