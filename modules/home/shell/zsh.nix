{
  config,
  lib,
  ...
}: {
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      source ${config.home.homeDirectory}/.config/zsh/theme.zsh-theme
    '';
  };

  imports = [
    ./aliases.nix
  ];
}
