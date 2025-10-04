{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
  ];

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      source ${config.home.homeDirectory}/.config/zsh/theme.zsh-theme
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-completions}/share/zsh/site-functions
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

      autoload -Uz compinit
      compinit

      eval "$(ssh-agent -s)"
      ssh-add ~/ssh-keys/github
    '';

    envExtra = ''
      bindkey "\e[1;5D" backward-word # RCtrl + Left
      bindkey "\e[1;5C" forward-word # RCtrl + Right
      bindkey "\e[1;5A" beginning-of-line # RCtrl + Up
      bindkey "\e[1;5B" end-of-line # RCtrl + Down

      bindkey "\e[1;6D" backward-word # RCtrl + Shift + Left
      bindkey "\e[1;6C" forward-word # RCtrl + Shift + Right
      bindkey "\e[1;6A" beginning-of-line # RCtrl + Shift + Up
      bindkey "\e[1;6B" end-of-line # RCtrl + Shift + Down

    '';
  };

  imports = [
    ./aliases.nix
  ];
}
