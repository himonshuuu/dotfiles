import QtQuick
import Quickshell.Io

// IPC surface: qs ipc call bluetooth <toggle|open|hide|info>
Item {
    id: ipc
    visible: false

    // services/bluetooth/Bluetooth.qml
    property var bt

    IpcHandler {
        target: "bluetooth"

        function toggle(): void { ipc.bt.togglePanel() }
        function open(): void { ipc.bt.openPanel() }
        function hide(): void { ipc.bt.closePanel() }

        function info(): void {
            const list = ipc.bt.list;
            var names = [];
            for (var i = 0; i < list.length; i++) {
                const d = list[i];
                names.push((d.deviceName || d.name || "?")
                    + (d.connected ? "+"
                        : (d.paired || d.bonded) ? "*" : ""));
            }
            console.log("bluetooth adapter=" + ipc.bt.adapterName
                + " powered=" + ipc.bt.powered
                + " scanning=" + ipc.bt.scanning
                + " open=" + ipc.bt.open
                + " devices=[" + names.join(", ") + "]");
        }
    }
}
