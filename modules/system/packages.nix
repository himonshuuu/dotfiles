{
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    polkit_gnome
    networkmanagerapplet
    blueman
    brightnessctl
    playerctl
    jq
  ];
}
