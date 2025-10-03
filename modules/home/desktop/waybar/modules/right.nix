{ pkgs, config, ...}: {
  tray = {
    icon-size = 12;
    spacing = 10;
  };

  network = {
    format-wifi = "󰈀  {bandwidthUpBits}  {bandwidthDownBits}";
    format-ethernet = "󰈁  {bandwidthUpBits}  {bandwidthDownBits}";
    tooltip-format = "{ifname} via {gwaddr}";
    format-linked = "{ifname} (No IP)";
    format-disconnected = "󰈂 Disconnected";
    interval = 1;
  };

  cpu = {
    interval = 1;
    format = "󰍛 {usage}%";
    rotate = 0;
    format-alt = "󰍛 {usage}%";
  };

  temperature = {
    format = "{temperatureC}°C ";
    critical-threshold = 80;
    format-critical = "{temperatureC}°C ";
    interval = 1;
  };

  memory = {
    states = {
      c = 90;
      h = 60;
      m = 30;
    };
    interval = 1;
    format-alt = "󰾆 {percentage}%";
    rotate = 0;
    format-m = "󰾅 {used:0.1f}GB";
    format-h = "󰓅 {used:0.1f}GB";
    format-c = "󰐡 {used:0.1f}GB";
    format = "󰾆 {used:0.1f}GB";
    max-length = 10;
    tooltip = true;
    tooltip-format = "󰾆 {percentage}% 󰍛 {used:0.1f}GB/{total:0.1f}GB";
  };

  "custom/fanctl" = {
    format = "{}";
    tooltip = true;
    interval = 1;
    exec = "~/.config/waybar/scripts/fanctl status";
    tooltip-format = "{}";
    on-click = "~/.config/waybar/scripts/fanctl";
    return-type = "json";
  };

  battery = {
    states = {
      good = 95;
      warning = 30;
      critical = 20;
    };
    format = "{icon} {capacity}%";
    format-charging = "󰂄 {capacity}%";
    format-plugged = "󰂄 {capacity}%";
    format-alt = "{time} {icon}";
    format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
    interval = 1;
  };

  "power-profiles-daemon" = {
    format = "{icon}";
    tooltip-format = "{profile} : {driver}";
    tooltip = true;
    format-icons = {
      default = "󰓅";
      performance = "󰓅";
      balanced = "";
      power-saver = "";
    };
  };

  "custom/power-menu" = {
    format = "<span font=\"12px\">󰐥</span>";
    tooltip = false;
    menu = "on-click";
    menu-file = "$HOME/.config/waybar/menus/power.menu.xml";
    menu-actions = {
      shutdown = "shutdown now";
      reboot = "reboot";
      sleep = "systemctl suspend";
      hibernate = "systemctl hibernate";
      logout = "hyprctl dispatch exit";
    };
  };
}
