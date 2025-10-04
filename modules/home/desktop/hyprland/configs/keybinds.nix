{ pkgs, config, ... }: let
  mainMod = "SUPER";
  scripts = "bash ~/.config/hypr/scripts";
in {
  bind = [
    "${mainMod}, Q, killactive,"
    "${mainMod}, W, togglefloating,"
    "${mainMod}, M, exit,"

    "${mainMod}, T, exec, [float;size 700 500;center] kitty"

    "${mainMod}, E, exec, thunar"

    "${mainMod}, A, exec, rofi -no-config -no-lazy-grab -show drun -theme ~/.config/rofi/drun.rasi"

    "${mainMod}+SHIFT ALT, P, exec, ${scripts}/screenshot window-freeze"
    "${mainMod}+SHIFT, P, exec, ${scripts}/screenshot window"
    "${mainMod}, P, exec, ${scripts}/screenshot region"

    "${mainMod}+SHIFT ALT, O, exec, ${scripts}/screenshot monitor-freeze"
    "${mainMod}+SHIFT, O, exec, ${scripts}/screenshot monitor"
    "${mainMod}, O, exec, ${scripts}/screenshot active"
    "${mainMod}+ALT, O, exec, ${scripts}/screenshot clipboard"

    "${mainMod}+ALT, R, exec, ${scripts}/wallchange -r"
    "${mainMod}+ALT, N, exec, ${scripts}/wallchange -n"
    "${mainMod}+ALT, P, exec, ${scripts}/wallchange -p"

    "${mainMod}, TAB, movefocus, d"

    "${mainMod}, left, movefocus, l"
    "${mainMod}, right, movefocus, r"
    "${mainMod}, up, movefocus, u"
    "${mainMod}, down, movefocus, d"

    "${mainMod}, 1, workspace, 1"
    "${mainMod}, 2, workspace, 2"
    "${mainMod}, 3, workspace, 3"
    "${mainMod}, 4, workspace, 4"
    "${mainMod}, 5, workspace, 5"
    "${mainMod}, 6, workspace, 6"
    "${mainMod}, 7, workspace, 7"
    "${mainMod}, 8, workspace, 8"
    "${mainMod}, 9, workspace, 9"
    "${mainMod}, 0, workspace, 10"

    "${mainMod}+SHIFT, 1, movetoworkspace, 1"
    "${mainMod}+SHIFT, 2, movetoworkspace, 2"
    "${mainMod}+SHIFT, 3, movetoworkspace, 3"
    "${mainMod}+SHIFT, 4, movetoworkspace, 4"
    "${mainMod}+SHIFT, 5, movetoworkspace, 5"
    "${mainMod}+SHIFT, 6, movetoworkspace, 6"
    "${mainMod}+SHIFT, 7, movetoworkspace, 7"
    "${mainMod}+SHIFT, 8, movetoworkspace, 8"
    "${mainMod}+SHIFT, 9, movetoworkspace, 9"
    "${mainMod}+SHIFT, 0, movetoworkspace, 10"

    "${mainMod}, S, togglespecialworkspace, magic"
    "${mainMod} SHIFT, S, movetoworkspace, special:magic"

    "${mainMod}, mouse_down, workspace, e+1"
    "${mainMod}, mouse_up, workspace, e-1"
  ];

  bindm = [
    "${mainMod}, Z, movewindow"
    "${mainMod}, X, resizewindow"
    "${mainMod}, mouse:272, movewindow"
    "${mainMod}, mouse:273, resizewindow"
  ];

  bindel = [
    ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
    ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
    ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
  ];

  bindl = [
    ", XF86AudioNext, exec, playerctl next"
    ", XF86AudioPause, exec, playerctl play-pause"
    ", XF86AudioPlay, exec, playerctl play-pause"
    ", XF86AudioPrev, exec, playerctl previous"
  ];
}
