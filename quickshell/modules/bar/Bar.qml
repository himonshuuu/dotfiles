import QtQuick.Shapes
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Qt5Compat.GraphicalEffects
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick.Window
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris

Scope {
    id: root
    property var shellRoot

    WlrLayershell {
        id: bar
        anchors {
            top: true
            bottom: true
            left: true
        }
        layer: WlrLayer.Top
        implicitWidth: 32 + 2 + 4 + 4
        color: "transparent"

        margins {
            left: 0
            right: 0
            top: 0
            bottom: 0
        }

        Rectangle {
            anchors.fill: parent
            color: '#222222'
        }

    }
   
}

