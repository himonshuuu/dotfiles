{pkgs, config, ...}: let
  monitorConfig = import ./configs/monitor.nix { inherit pkgs config; };
  inputConfig = import ./configs/input.nix { inherit pkgs config; };
  generalConfig = import ./configs/general.nix { inherit pkgs config; };
  decorationConfig = import ./configs/decoration.nix { inherit pkgs config; };
  animationsConfig = import ./configs/animations.nix { inherit pkgs config; };
  dwindleConfig = import ./configs/dwindle.nix { inherit pkgs config; };
  gesturesConfig = import ./configs/gestures.nix { inherit pkgs config; };
  miscConfig = import ./configs/misc.nix { inherit pkgs config; };
  keybindsConfig = import ./configs/keybinds.nix { inherit pkgs config; };
  windowrulesConfig = import ./configs/windowrules.nix { inherit pkgs config; };
  startupsConfig = import ./configs/startups.nix { inherit pkgs config; };
in {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;

    settings = {
      monitor = monitorConfig.monitor;
      input = inputConfig.input;
      general = generalConfig.general;
      decoration = decorationConfig.decoration;
      animations = animationsConfig.animations;
      dwindle = dwindleConfig.dwindle;
      gestures = gesturesConfig.gestures;
      misc = miscConfig.misc;
      bind = keybindsConfig.bind;
      bindm = keybindsConfig.bindm;
      windowrulev2 = windowrulesConfig.windowrulev2;
      exec-once = startupsConfig.exec-once;
      exec = startupsConfig.exec;
    };
  };
  home.file.".config/hypr/scripts" = {
    source = ./scripts;
    recursive = true;
    executable = true;
  };
}
