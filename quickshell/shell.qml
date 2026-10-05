//@ pragma IconTheme Tela-circle-blue-dark
import QtQuick
import Quickshell

// Composition root: services/ (logic) wired to components/ (UI).
import "services/notifications" as NotifService
import "services/power" as Power
import "services/apps" as Apps
import "services/media" as Media
import "services/audio" as Audio
import "services/display" as Display
import "services/wallpaper" as WallpaperService
import "services/screenshot" as Shot
import "services/bluetooth" as BluetoothService
import "services/polkit" as Polkit
import "components/bar" as Bar
import "components/osd" as Osd
import "components/notifications" as Notifications
import "components/launcher" as Launcher
import "components/powermenu" as PowerMenu
import "components/lockscreen" as LockScreen
import "components/wallpaper" as Wallpaper
import "components/screenshot" as Screenshot
import "components/bluetooth" as Bluetooth
import "components/polkit" as PolkitUi

ShellRoot {
    // background logic - created once, shared by every screen
    Power.Notifier {}
    Power.Battery { id: batteryService }
    Power.Session { id: sessionService }
    Media.Player { id: mediaService }
    Apps.Running { id: appsService }
    Apps.Catalog { id: catalogService }
    Audio.Volume { id: volumeService }
    Display.Brightness { id: brightnessService }

    NotifService.NotificationCenter { id: notifCenter }

    // qs ipc call notifcenter <info|dump|invokeFirst|dismissAll|clearHistory>
    NotifService.Ipc { center: notifCenter }

    // the wallpaper replaces awww-daemon: quickshell draws its own background
    WallpaperService.Wallpaper { id: wallpaperService }

    // qs ipc call wallpaper <random|info>
    WallpaperService.Ipc { wallpaper: wallpaperService }

    // region screenshot - replaces the grim/slurp/wl-copy/notify-send bash line
    Shot.Shutter { id: shutterService }

    // qs ipc call screenshot <pick|full|info>
    Shot.Ipc { shutter: shutterService }

    // bluetooth adapter + devices - replaces blueman-manager
    BluetoothService.Bluetooth { id: bluetoothService }

    // qs ipc call bluetooth <toggle|open|hide|info>
    BluetoothService.Ipc { bt: bluetoothService }

    // polkit auth agent - registering is all this does; pkexec finds us
    Polkit.Agent { id: polkitService }

    // qs ipc call polkit <info>
    Polkit.Ipc { agent: polkitService }

    // one lock surface per output, owned at the shell root rather than per
    // screen - the session-lock protocol already covers every monitor
    LockScreen.LockScreen { session: sessionService }

    Variants {
        model: Quickshell.screens
        Scope {
            id: v
            property var modelData

            // background layer - sits under every other surface
            Wallpaper.Backdrop {
                screen: v.modelData
                wallpaper: wallpaperService
            }

            // qs ipc call screenshot <pick|full|info>
            Screenshot.RegionPicker {
                screen: v.modelData
                shutter: shutterService
            }

            Notifications.NotifViewer {
                id: notifViewer
                screen: v.modelData
                center: notifCenter
            }

            Notifications.PopupStack {
                screen: v.modelData
                notifications: notifCenter.popups
                rightGap: notifViewer.isOpen ? notifViewer.implicitWidth : 0
            }

            Bar.Island {
                screen: v.modelData
                toggleNotif: function() { notifViewer.isOpen = !notifViewer.isOpen }
                apps: appsService
                media: mediaService
                battery: batteryService
                bluetooth: bluetoothService
            }

            Osd.Osd {
                screen: v.modelData
                volume: volumeService
                brightness: brightnessService
            }

            // qs ipc call bluetooth <toggle|open|hide>
            Bluetooth.BluetoothPanel {
                screen: v.modelData
                bt: bluetoothService
            }

            // pkexec / anything else that asks polkitd for privileges
            PolkitUi.AuthDialog {
                screen: v.modelData
                agent: polkitService
            }

            // qs ipc call launcher <toggle|open|hide>
            Launcher.Launcher {
                screen: v.modelData
                catalog: catalogService
            }

            // qs ipc call powermenu <toggle|open|hide>
            PowerMenu.PowerMenu {
                screen: v.modelData
                session: sessionService
            }
        }
    }
}
