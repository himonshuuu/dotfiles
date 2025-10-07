{ pkgs, ... }: {
  home.packages = with pkgs; [
    vesktop
    spotify
    vivaldi
  ];
}