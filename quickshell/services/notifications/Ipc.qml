import QtQuick
import Quickshell.Io

// IPC surface: qs ipc call notifcenter <function>
Item {
    id: ipc
    visible: false

    // NotificationCenter - everything below is read or called through it
    property var center

    IpcHandler {
        target: "notifcenter"

        function info(): void {
            console.log("notifcenter live=" + ipc.center.live.length
                + " history=" + ipc.center.history.length
                + " popups=" + ipc.center.popups.length
                + " items=" + ipc.center.items.length);
        }

        function dump(): void {
            var items = ipc.center.items;
            for (var i = 0; i < items.length; i++) {
                var r = items[i];
                console.log("dump id=" + r.id
                    + " active=" + r.active
                    + " app=" + JSON.stringify(r.app)
                    + " icon=" + JSON.stringify(r.icon)
                    + " image=" + JSON.stringify(r.image)
                    + " urgency=" + r.urgency
                    + " expireTimeout=" + r.expireTimeout
                    + " actions=" + r.actionList.length);
            }
        }

        // same code path as the action buttons in the viewer
        function invokeFirst(index: int): void {
            var items = ipc.center.items;
            for (var i = 0; i < items.length; i++) {
                if (items[i].active && items[i].actionList.length > 0) {
                    ipc.center.invoke(items[i], index);
                    return;
                }
            }
            console.log("invokeFirst: no live notification with actions");
        }

        function dismissAll(): void { ipc.center.dismissAll() }
        function clearHistory(): void { ipc.center.clearHistory() }
    }
}
