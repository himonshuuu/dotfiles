{
  ...
}: {
  programs.kitty = {
    enable = true;
    settings = {
      linux_display_server = "x11";
      font_family = "JetBrainsMono Nerd Font Mono";
      bold_font = "JetBrainsMono Nerd Font Mono Bold";
      italic_font = "JetBrainsMono Nerd Font Mono Italic";
      bold_italic_font = "JetBrainsMono Nerd Font Mono Bold Italic";
      enable_audio_bell = "no";
      font_size = 10;
      window_padding_width = 4;
      window_margin_width = 4;
      cursor_trail = 1;
      initial_window_width = "100c";
      initial_window_height = "30c";
      background_opacity = "0.60";

      # Colorscheme
      background = "#000000";
      foreground = "#c0caf5";

      color0 = "#414868";
      color8 = "#414868";

      color1 = "#f7768e";
      color9 = "#f7768e";

      color2 = "#73daca";
      color10 = "#73daca";

      color3 = "#e0af68";
      color11 = "#e0af68";

      color4 = "#7aa2f7";
      color12 = "#7aa2f7";

      color5 = "#bb9af7";
      color13 = "#bb9af7";

      color6 = "#7dcfff";
      color14 = "#7dcfff";

      color7 = "#c0caf5";
      color15 = "#c0caf5";

      cursor = "#c0caf5";
      cursor_text_color = "#1a1b26";

      selection_foreground = "none";
      selection_background = "#28344a";

      url_color = "#fbff00";

      active_border_color = "#3d59a1";
      inactive_border_color = "#101014";
      bell_border_color = "#e0af68";

      tab_bar_style = "fade";
      tab_fade = 1;
      active_tab_foreground = "#3d59a1";
      active_tab_background = "#16161e";
      active_tab_font_style = "bold";
      inactive_tab_foreground = "#787c99";
      inactive_tab_background = "#16161e";
      inactive_tab_font_style = "bold";
      tab_bar_background = "#101014";

      macos_titlebar_color = "#16161e";
    };
  };
}
