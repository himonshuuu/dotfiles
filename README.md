# dotfiles

Arch Linux + Hyprland (Lua) with a Quickshell island bar.

| folder | what |
|---|---|
| `hypr/` | monitors, appearance, input, keybinds, autostart, window rules |
| `quickshell/` | bar, OSD, notifications, launcher, power menu, lock screen, wallpaper, screenshot, bluetooth, polkit agent |
| `kitty/` | terminal |

## Install

```sh
git clone <repo-url> ~/.dotfiles
~/.dotfiles/install.sh
```

`install.sh` symlinks every folder in the repo into `~/.config`, backing up
anything already there to `<name>.bak.<timestamp>`. It is safe to re-run.

- `-n`, `--dry-run` — show what it would do
- `--unlink` — remove the links this repo created

## Layout

`quickshell/` is split by role:

- `services/` — background logic, never draws anything
- `components/` — markup only
- `utils/` — logic shared between components
- `config/` — design tokens (`theme.js`)

Services are instantiated once in `shell.qml` and passed into components.

## IPC

```sh
qs ipc call <target> <function>
```

Targets: `notifcenter`, `launcher`, `powermenu`, `wallpaper`, `screenshot`, `bluetooth`, `polkit`.

After config changes Quickshell hot-reloads; a clean restart is
`pkill -x quickshell; qs`.
