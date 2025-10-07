{
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    blueman
    brightnessctl
    playerctl
    jq
    gvfs

    nwg-look
    
    xdg-utils
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      glib
      zlib
      openssl
      libuuid
      libxkbcommon
      wayland
      xorg.libX11
      xorg.libxcb
      xorg.libXrandr
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
    ];
  };
}
