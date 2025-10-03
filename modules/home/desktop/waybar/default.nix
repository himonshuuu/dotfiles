{pkgs, config, ...}: let
  leftModules = import ./modules/left.nix { inherit pkgs config; };
  centerModules = import ./modules/center.nix { inherit pkgs config; };
  rightModules = import ./modules/right.nix { inherit pkgs config; };
in {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        mod = "dock";
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;
        height = 30;
        reload_style_on_change = true;

        modules-left = [
          "custom/menu"
          "custom/screenrecord"
          "pulseaudio"
          "pulseaudio#microphone"
          "backlight"
          "bluetooth"
          "custom/mpris"
        ];
        modules-center = [
          "hyprland/workspaces"
          "custom/weather"
          "clock"
          "custom/notification"
        ];
        modules-right = [
          "tray"
          "network"
          "cpu"
          "temperature"
          "memory"
          "custom/fanctl"
          "battery"
          "power-profiles-daemon"
          "custom/power-menu"
        ];

        "hyprland/workspaces" = centerModules."hyprland/workspaces";
        "custom/weather" = centerModules."custom/weather";
        "clock" = centerModules.clock;
        "custom/notification" = centerModules."custom/notification";

        "custom/menu" = leftModules."custom/menu";
        "custom/screenrecord" = leftModules."custom/screenrecord";
        "pulseaudio" = leftModules.pulseaudio;
        "pulseaudio#microphone" = leftModules."pulseaudio#microphone";
        "backlight" = leftModules.backlight;
        "bluetooth" = leftModules.bluetooth;
        "custom/mpris" = leftModules."custom/mpris";

        "tray" = rightModules.tray;
        "network" = rightModules.network;
        "cpu" = rightModules.cpu;
        "temperature" = rightModules.temperature;
        "memory" = rightModules.memory;
        "custom/fanctl" = rightModules."custom/fanctl";
        "battery" = rightModules.battery;
        "power-profiles-daemon" = rightModules."power-profiles-daemon";
        "custom/power-menu" = rightModules."custom/power-menu";
      };
    };

    style = builtins.readFile ./style.css;
  };
  home.file.".config/waybar/scripts" = {
    source = ./scripts;
    recursive = true;
    executable = true;
  };
  home.file.".config/waybar/menus" = {
    source = ./menus;
    recursive = true;
  };
}
