{ pkgs, config, ...}: {
  "custom/menu" = {
    format = "<span font=\"16px\">󱄅</span>";
    tooltip = false;
    menu = "on-click";
    menu-file = "~/.config/waybar/menus/main.menu.xml";
    menu-actions = {
      update_system = "kitty sh -c 'sudo pacman -Syu; exec zsh'";
      open_terminal = "kitty";
      open_code = "code";
      open_file_manager = "thunar";
      exit = "notify-send 'Exiting Hyprland in 5sec' && sleep 5 && hyprctl dispatch exit";
      record_region = "~/.config/waybar/scripts/screenrecord region";
      record_monitor = "~/.config/waybar/scripts/screenrecord monitor";
      record_window = "~/.config/waybar/scripts/screenrecord window";
      record_status = "~/.config/waybar/scripts/screenrecord status";
      record_stop = "~/.config/waybar/scripts/screenrecord stop";
    };
  };

  "custom/screenrecord" = {
    format = "{}";
    tooltip = false;
    return-type = "json";
    interval = 1;
    exec = "~/.config/waybar/scripts/screenrecord status";
    on-click = "~/.config/waybar/scripts/screenrecord stop";
  };

  pulseaudio = {
    format = "{icon} {volume}%";
    format-muted = "<s>{icon}</s> Muted";
    tooltip-format = "{format_sink} {volume}%";
    tooltip = true;
    on-click = "wpctl set-mute @DEFAULT_SINK@ toggle";
    on-scroll-up = "wpctl set-volume @DEFAULT_SINK@ 1%+";
    on-scroll-down = "wpctl set-volume @DEFAULT_SINK@ 1%-";
    scroll-step = 1;
    format-icons = {
      headphone = "󰋋";
      hands-free = "󰋋";
      headset = "󰋋";
      phone = "󰄜";
      portable = "󰦧";
      default = ["󰕿" "󰕾" "󰕾"];
    };
  };

  "pulseaudio#microphone" = {
    format = "{format_source}";
    format-source = "󰍬 {volume}%";
    format-source-muted = "󰍭 Muted";
    tooltip-format = "{format_source} {volume}%";
    tooltip = true;
    on-click = "wpctl set-mute @DEFAULT_SOURCE@ toggle";
    on-scroll-up = "wpctl set-volume @DEFAULT_SOURCE@ 1%+";
    on-scroll-down = "wpctl set-volume @DEFAULT_SOURCE@ 1%-";
    scroll-step = 1;
  };

  backlight = {
    format = "{icon} {percent}%";
    format-icons = ["󰃞" "󰃟" "󰃠"];
    on-scroll-up = "brightnessctl set 1%+";
    on-scroll-down = "brightnessctl set 1%-";
    min-length = 6;
  };

  bluetooth = {
    format = "󰂯 {status}";
    format-disabled = " 󰂯 Disabled";
    format-connected = "󰂯 󰋋";
    tooltip-format = "{device_alias}";
    tooltip-format-connected = "󰂯  {device_alias} 󰁹 {device_battery_percentage}%";
    tooltip-format-enumerate-connected = "{device_alias}";
    interval = 1;
  };

  "custom/mpris" = {
    format = "{} ";
    exec = "~/.config/waybar/scripts/playerinfo";
    return-type = "json";
    interval = 1;
    escape = true;
    tooltip = true;
    on-click = "playerctl play-pause";
    on-click-right = "playerctl next";
    on-click-middle = "playerctl previous";
    on-scroll-up = "playerctl position 5+";
    on-scroll-down = "playerctl position 5-";
  };
}
