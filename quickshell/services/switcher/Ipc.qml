import QtQuick
import Quickshell.Io

// IPC surface: qs ipc call switcher <open|next|prev|confirm|cancel|info>
Item {
    id: ipc
    visible: false

    property var sw

    IpcHandler {
        target: "switcher"

        function open(): void { ipc.sw.open() }
        function next(): void { ipc.sw.next() }
        function prev(): void { ipc.sw.prev() }
        function confirm(): void { ipc.sw.confirm() }
        function cancel(): void { ipc.sw.close() }
        function info(): string { return ipc.sw.info() }
    }
}
