{
  config,
  lib,
  ...
}: {
  imports = [
    ./zsh.nix
    ./aliases.nix
  ];

  home.file.".config/zsh/theme.zsh-theme" = {
    source = ./mytheme.zsh-theme;
  };
}
