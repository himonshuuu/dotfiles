{pkgs, ...}: {
  services.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;

    alsa = {
      enable = true;
      support32Bit = true;
    };

    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  users.users.human.extraGroups = ["audio"];

  environment.systemPackages = with pkgs; [
    pavucontrol
    pamixer
    alsa-utils
    helvum
  ];
}
