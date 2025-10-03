{
  ...
}: {
  programs.zsh.shellAliases = {
    ll = "ls -alF";
    la = "ls -A";
    l = "ls -CF";
    gs = "git status";
    gc = "git commit";
    gl = "git log --oneline --graph --decorate";
    ".." = "cd ..";
    update = "nix flake update";
    grep = "grep --color=auto";
    ip = "ip --color=auto";
    
    rebuild = "sudo nixos-rebuild switch --flake ~/nixdot#nixos";
    clear = "printf '\\033[3J\\033[H\\033[2J'";
    cleanbuilds = "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +3";
    cleangarbage = "sudo nix-collect-garbage -d";
    listbuilds = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
  };
}
