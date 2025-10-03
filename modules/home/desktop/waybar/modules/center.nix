{ pkgs, config, ...}: {
  "hyprland/workspaces" = {
    format = "{name} {windows}";
    format-window-separator = " ";
    workspace-taskbar = {
      enable = true;
      update-active-window = true;
      format = "{icon}";
      icon-size = 20;
      on-click-window = "~/.config/waybar/scripts/focuswindow {address} {button}";
    };
  };

  "custom/weather" = {
    tooltip = true;
    format = "{}";
    interval = 30;
    exec = "~/.config/waybar/scripts/weather";
    return-type = "json";
  };

  clock = {
    format = "{:%I:%M:%S %p 󰃭 %d·%m·%Y}";
    rotate = 0;
    interval = 1;
    tooltip-format = "<span>{calendar}</span>";
    on-click = "swaync-client -t -sw";
    calendar = {
      mode = "month";
      mode-mon-col = 3;
      on-scroll = 1;
      on-click-right = "mode";
      format = {
        months = "<span color='#ffead3'><b>{}</b></span>";
        weekdays = "<span color='#ffcc66'><b>{}</b></span>";
        today = "<span color='#ff6699'><b>{}</b></span>";
      };
    };
    actions = {
      on-click-right = "mode";
      on-click-forward = "tz_up";
      on-click-backward = "tz_down";
      on-scroll-up = "shift_up";
      on-scroll-down = "shift_down";
    };
  };

  "custom/notification" = {
    tooltip = false;
    format = "{icon}";
    format-icons = {
      notification = "<span foreground='red'><small><sup>⬤</sup></small></span>";
      none = " ";
      dnd-notification = "<span foreground='red'><small><sup>⬤</sup></small></span>";
      dnd-none = " ";
    };
    return-type = "json";
    exec-if = "which swaync-client";
    exec = "swaync-client -swb";
    on-click = "sleep 0.1 && swaync-client -t -sw";
    on-click-right = "sleep 0.1 && swaync-client -d -sw";
    escape = true;
  };
}
