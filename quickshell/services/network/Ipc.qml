import QtQuick
import Quickshell.Io

// IPC surface: qs ipc call network <info>
Item {
    id: ipc
    visible: false

    // services/network/Network.qml
    property var net

    IpcHandler {
        target: "network"

        function info(): string {
            const n = ipc.net
            return JSON.stringify({
                rx: Math.round(n.rxRate),
                tx: Math.round(n.txRate),
                links: n.links
            })
        }
    }
}
