import QtQuick
import Quickshell.Io

// IPC surface: qs ipc call polkit <info> (diagnostics only)
Item {
    id: ipc
    visible: false

    // services/polkit/Agent.qml
    property var agent

    IpcHandler {
        target: "polkit"

        function info(): void {
            const f = ipc.agent.flow;
            const who = f ? f.selectedIdentity : null;
            console.log("polkit registered=" + ipc.agent.registered
                + " active=" + ipc.agent.active
                + " prompting=" + ipc.agent.prompting
                + (f ? " action=" + f.actionId
                       + " icon=\"" + f.iconName + "\""
                       + " prompt=\"" + f.inputPrompt + "\""
                       + " echo=" + f.responseVisible
                       + " identities=" + f.identities.length
                       + " sel=" + (who && who.displayName ? who.displayName : "-")
                       + " done=" + f.isCompleted
                    : " flow=null"));
        }
    }
}
