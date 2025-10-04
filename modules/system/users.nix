{
  pkgs,
  user,
  ... 
}: {
  programs.zsh.enable = true;
  users.users.human = {
    isNormalUser = true;
    description = user;
    shell = pkgs.zsh;
    extraGroups = ["networkmanager" "wheel" "audio" "video" "input"];

    packages = with pkgs; [
      vesktop
      spotify
      vivaldi
    ];
  };
}
