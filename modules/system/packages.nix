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
  ];
}
