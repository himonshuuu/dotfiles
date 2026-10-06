import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

// Session actions behind the power menu; locked gates the lock screen and survives hot reloads.
Item {
    id: root

    readonly property bool locked: state.locked

    signal lockRequested()

    function lock() { state.locked = true; root.lockRequested() }
    function unlock() { state.locked = false }

    function logout() {
        // the Hyprland config is Lua, so the dispatcher has to be evaluated
        Hyprland.dispatch("hl.dsp.exit()")
    }

    function reboot()  { Quickshell.execDetached(["systemctl", "reboot"]) }
    function poweroff() { Quickshell.execDetached(["systemctl", "poweroff"]) }

    // qs ipc call session info
    IpcHandler {
        target: "session"
        function info(): string { return JSON.stringify({ locked: state.locked }) }
    }

    PersistentProperties {
        id: state
        reloadableId: "sessionState"
        property bool locked: true

        // fires after restore, so only a session that was already locked re-arms
        onLoaded: { if (state.locked) root.lockRequested() }
    }
}
