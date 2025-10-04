{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    mpv
    vlc
    ffmpeg
    pavucontrol

    wf-recorder
  ];
}
