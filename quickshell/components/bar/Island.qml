import QtQuick
import Quickshell
import Quickshell.Wayland

// One layer surface, three islands: taskbar, clock + player, controls.
PanelWindow {
    id: win

    anchors { top: true; left: true; right: true }
    implicitHeight: 42
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusiveZone: 36
    WlrLayershell.namespace: "island"

    // required so they are set before any binding below is evaluated
    required property var apps      // services/apps/Running.qml
    required property var media     // services/media/Player.qml
    required property var battery   // services/power/Battery.qml
    required property var bluetooth // services/bluetooth/Bluetooth.qml
    property var toggleNotif: function() {}
    property var openPowerMenu: function() {}

    Taskbar {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 8
        anchors.topMargin: 6
        apps: win.apps
    }

    Center {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 6
        media: win.media
    }

    Controls {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 8
        anchors.topMargin: 6
        battery: win.battery
        bluetooth: win.bluetooth
        toggleNotif: win.toggleNotif
        openPowerMenu: win.openPowerMenu
    }
}
