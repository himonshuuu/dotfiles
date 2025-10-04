{...}: {
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./boot.nix
    ./hardware.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./security.nix
    ./users.nix
    ./packages.nix
  ];

  services.power-profiles-daemon = {
    enable = true;
  };
}
