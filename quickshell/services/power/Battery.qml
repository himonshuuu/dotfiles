import QtQuick
import Quickshell.Services.UPower

// Laptop battery state straight from UPower, plus the nerd-font glyph the bar
// shows next to the percentage. One step per 10%.
Item {
    id: root

    property var device: UPower.displayDevice

    readonly property bool ready: device ? (device.ready && device.isLaptopBattery) : false
    readonly property real raw: ready ? device.percentage : -1
    readonly property int percentage: (raw < 0) ? 0 : Math.round(raw * 100)

    readonly property bool charging: ready && (device.state === UPowerDeviceState.Charging
                                             || device.state === UPowerDeviceState.PendingCharge)
    readonly property bool full: ready && device.state === UPowerDeviceState.FullyCharged

    readonly property string glyph: {
        if (!ready) return ""
        if (charging) return "󰂄"              // charging
        const p = percentage
        if (p >= 100) return "󱟢"               // full
        if (p >= 90) return "󰂂"
        if (p >= 80) return "󰁁"
        if (p >= 70) return "󰂀"
        if (p >= 60) return "󰁿"
        if (p >= 50) return "󰁾"
        if (p >= 40) return "󰁽"
        if (p >= 30) return "󰁽"
        if (p >= 20) return "󰁻"
        if (p >= 10) return "󰁺"
        return "󰂎"                                  // below 10
    }
}
