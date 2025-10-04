{
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes" "pipe-operators"];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}
