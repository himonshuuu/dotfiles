{ pkgs, lib, config, ... }:
{

  home.packages = with pkgs; [
    polkit_gnome
    gnome-keyring
    hyprpaper
    gvfs
  ];

  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];

  services.polkit-gnome = {
    enable = true;
    package = pkgs.polkit_gnome;
  };

  services.gnome-keyring = {
    enable = true;
    package = pkgs.gnome-keyring;
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc= "on";
      splash = true;
      splash_offset = 1.0;
    };
  };

  programs.ssh.enable = true;
  programs.ssh.startAgent = true;

  home.activation.startupScripts = [
    {
      name = "ssh-add-github-key";
      text = ''
        #!/usr/bin/env bash
        # silently add custom GitHub key
        pgrep ssh-agent >/dev/null || eval "$(ssh-agent -s)"
        ssh-add -q ~/ssh-keys/github
      '';
    }
  ];

}
