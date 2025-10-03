{pkgs, ...}: {
  home.packages = with pkgs; [
    nil

    vscode
    git
    code-cursor
  ];

  programs.git = {
    enable = true;
    userName = "himonshuuu";
    userEmail = "mail@himonshuuu.co";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
    };
  };
}
