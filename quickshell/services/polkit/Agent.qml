import QtQuick
import Quickshell.Services.Polkit

// Polkit auth agent (replaces polkit-gnome / hyprpolkitagent). Creating PolkitAgent registers us.
Item {
    id: root
    visible: false

    PolkitAgent { id: agent }

    readonly property bool registered: agent.isRegistered
    readonly property bool active: agent.isActive
    readonly property var flow: agent.flow

    // polkitd is actually waiting on us for a reply right now
    readonly property bool prompting: !!flow && flow.isResponseRequired && !flow.isCompleted

    function submit(password) {
        if (root.prompting) flow.submit(password);
    }

    function cancel() {
        if (flow && !flow.isCompleted) flow.cancelAuthenticationRequest();
    }
}
