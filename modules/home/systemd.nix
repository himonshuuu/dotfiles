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

  services.ssh-agent = {
    enable = true;
    package = pkgs.openssh;
  };

  home.activation = {
    ssh-add-github-key = lib.mkIf config.programs.ssh.enable {
      after = [ "ssh-agent.service" ];
      wantedBy = [ "ssh-agent.service" ];
      script = ''
        ssh-add -q ~/ssh-keys/github
      '';
    };
  };

}
