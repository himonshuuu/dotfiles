import QtQuick
import Quickshell
import Quickshell.Services.UPower

// Charger plug/unplug + low-battery notifications (sent to the quickshell
// notification daemon via notify-send)
Item {
    id: notifier

    // --- config ---
    property int lowThreshold: 15      // warn at <= 15%
    property int criticalThreshold: 5  // critical warn at <= 5%

    // icons bundled with the config (notify-send -i wants a file path)
    readonly property string iconCharger: path("icons/charger.svg")
    readonly property string iconUnplugged: path("icons/ac-adapter.svg")
    readonly property string iconLow: path("icons/low-battery.svg")

    property var bat: UPower.displayDevice
    property bool ready: bat ? bat.ready : false
    property int pct: ready ? Math.round(bat.percentage * 100) : -1

    // UPower.onBattery is the AC line itself, so this stays correct while the
    // battery tops up to Full on the charger (state would flip there and lie)
    readonly property bool onAc: !UPower.onBattery

    property bool charging: ready && (bat.state === UPowerDeviceState.Charging
                                      || bat.state === UPowerDeviceState.PendingCharge)

    property bool armed: false         // don't announce the state we booted into
    property bool lowWarned: false
    property bool criticalWarned: false

    Timer {
        interval: 4000
        running: notifier.ready
        onTriggered: notifier.armed = true
    }

    onOnAcChanged: {
        if (!armed) return
        if (onAc)
            notify("Charger connected", notifier.pct + "% — " + statusText(),
                   iconCharger, "normal")
        else
            notify("Charger disconnected", notifier.pct + "% — on battery",
                   iconUnplugged, "normal")

        // new power cycle: let the low-battery warning fire again
        lowWarned = false
        criticalWarned = false
        checkBattery()
    }

    onArmedChanged: if (armed) checkBattery()
    onPctChanged: checkBattery()

    function statusText() {
        if (pct >= 100 || bat.state === UPowerDeviceState.FullyCharged) return "full"
        return charging ? "charging" : "plugged in"
    }

    function checkBattery() {
        if (!armed || onAc || pct < 0) return
        if (pct <= criticalThreshold && !criticalWarned) {
            criticalWarned = true
            lowWarned = true
            notify("Battery critical", pct + "% remaining — plug in now",
                   iconLow, "critical")
        } else if (pct <= lowThreshold && !lowWarned) {
            lowWarned = true
            notify("Low battery", pct + "% remaining", iconLow, "normal")
        }
    }

    // Qt.resolvedUrl gives a "file://..." URL; notify-send -i wants a plain path
    function path(rel) {
        return Qt.resolvedUrl(rel).toString().replace(/^file:\/\//, "")
    }

    function notify(summary, body, iconPath, urgency) {
        const cmd = ["notify-send", "-t", "8000", "-u", urgency]
        if (iconPath && iconPath !== "") cmd.push("-i", iconPath)
        cmd.push(summary, body)
        Quickshell.execDetached(cmd)
    }
}
