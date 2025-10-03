{
  user,
  inputs,
  ...
}: {
  imports = [
    ./shell

    ./variables.nix
    ./theming

    ./desktop/waybar
    ./desktop/hyprland
    ./desktop/rofi

    ./configs

    ./apps

    ./browsers.nix
    ./fonts.nix
    ./packages.nix
    ./systemd.nix
    ./xdg.nix

    inputs.hyprland.homeManagerModules.default
  ];

  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "25.05";
}
