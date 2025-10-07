{ pkgs, ... }: {
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = ["JetBrainsMono Nerd Font" "Roboto Mono" "Ubuntu Mono"];
      sansSerif = ["JetBrainsMono Nerd Font" "Roboto" "IBM Plex Sans" "Ubuntu"];
      serif = ["IBM Plex Serif" "Liberation Serif"];
      emoji = ["Noto Color Emoji" "Fluent Emoji"];
    };
  };

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.adwaita-mono

    noto-fonts-emoji

    dejavu_fonts
    nerd-fonts.droid-sans-mono
    ibm-plex
    liberation_ttf
    roboto
    roboto-mono
    ubuntu-sans
    ubuntu-sans-mono

    # System fonts
    adwaita-fonts
    freefont_ttf
    texlivePackages.gnu-freefont
    noto-fonts
    terminus_font_ttf
  ];
}
