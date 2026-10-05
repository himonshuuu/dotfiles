import QtQuick
import Quickshell.Io

// IPC surface: qs ipc call wallpaper <random|info>
Item {
    id: ipc
    visible: false

    // services/wallpaper/Wallpaper.qml
    property var wallpaper

    IpcHandler {
        target: "wallpaper"

        function random(): void { ipc.wallpaper.random() }

        function info(): void {
            console.log("wallpaper current=" + ipc.wallpaper.current
                + " previous=" + ipc.wallpaper.previous
                + " files=" + ipc.wallpaper.files.length);
        }
    }
}
