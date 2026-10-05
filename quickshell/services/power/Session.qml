import QtQuick
import Quickshell
import Quickshell.Hyprland

// Session actions behind the power menu; lock() emits lockRequested, Quickshell owns the surface.
Item {
    id: root

    signal lockRequested()

    function lock() { root.lockRequested() }

    function logout() {
        // the Hyprland config is Lua, so the dispatcher has to be evaluated
        Hyprland.dispatch("hl.dsp.exit()")
    }

    function reboot()  { Quickshell.execDetached(["systemctl", "reboot"]) }
    function poweroff() { Quickshell.execDetached(["systemctl", "poweroff"]) }
}
