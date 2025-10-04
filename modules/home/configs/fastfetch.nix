{
    programs.fastfetch = {
        enable = true;
        settings = {
            logo = {
                source = "nixos";
                width = 34;
                height = 16;
                padding = {
                    left = 2;
                    right = 2;
                };
            };

            display = {
                separator = ":";
                key = {
                    width = 14;
                };
            };

            modules = [
                "break"
                {
                    type = "title";
                    key = " ";
                    format = "{6}{7}{8}";
                    color = "cyan";
                }
                {
                    type = "os";
                    key = "󱄅 OS";
                    format = "{2} {12}";
                    keyColor = "blue";
                }
                {
                    type = "kernel";
                    key = " Kernel";
                    format = "{1} {2}";
                    keyColor = "blue";
                }
                {
                    type = "packages";
                    key = "󰏗 Packages";
                    keyColor = "green";
                }
                {
                    type = "uptime";
                    key = " Uptime";
                    format = "{4}";
                    keyColor = "green";
                }
                "break"
                {
                    type = "host";
                    key = "󰇅 Host";
                    keyColor = "red";
                }
                {
                    type = "cpu";
                    key = " CPU";
                    format = "{1} ({2}) @ {7}";
                    keyColor = "red";
                }
                {
                    type = "gpu";
                    key = "󰢮 GPU";
                    format = "{1} {2} ({3})";
                    keyColor = "yellow";
                }
                {
                    type = "memory";
                    key = " Memory";
                    format = "{1} / {2} ({3})";
                    keyColor = "yellow";
                } 
                {
                    type = "swap";
                    key = "󰓢 Swap";
                    format = "{1} / {2} ({3})";
                    keyColor = "yellow";
                }
                {
                    type = "disk";
                    key = " Disk";
                    format = "{1} / {2} ({3})";
                    keyColor = "magenta";
                }
                "break"
                {
                    type = "de";
                    key = "󰧨 DE";
                    keyColor = "cyan";
                }
                {
                    type = "wm";
                    key = " WM";
                    keyColor = "cyan";
                }
                {
                    type = "terminal";
                    key = " Terminal";
                    format = "{1} {2}";
                    keyColor = "blue";
                }
                {
                    type = "shell";
                    key = " Shell";
                    keyColor = "blue";
                }
                {
                    type = "display";
                    key = "󰍹 Display";
                    format = "{1}x{2} @ {3}Hz";
                    keyColor = "green";
                }
                "break"
            ];
        };
    };
}
