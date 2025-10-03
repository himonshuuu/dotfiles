{ pkgs, config, ... }: {
  windowrulev2 = [
    "float, class:^(pavucontrol)$"
    "float, class:^(blueman-manager)$"
    "float, class:^(nm-connection-editor)$"
    "float, class:^(thunar)$"
    "float, class:^(org.kde.polkit-kde-authentication-agent-1)$"
  ];
}
