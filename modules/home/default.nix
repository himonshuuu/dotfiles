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

    ./fonts.nix
    ./packages.nix
    ./systemd.nix

    inputs.hyprland.homeManagerModules.default
  ];

  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "25.05";
}
