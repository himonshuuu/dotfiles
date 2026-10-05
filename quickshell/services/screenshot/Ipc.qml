import QtQuick
import Quickshell.Io

// IPC surface: qs ipc call screenshot <pick|full|info>
Item {
    id: ipc
    visible: false

    // services/screenshot/Shutter.qml
    property var shutter

    IpcHandler {
        target: "screenshot"

        function pick(): void { ipc.shutter.openPicker() }
        function full(): void { ipc.shutter.captureFull() }

        function info(): void {
            console.log("screenshot dir=" + ipc.shutter.dir
                + " picking=" + ipc.shutter.picking
                + " last=" + ipc.shutter.path);
        }
    }
}
