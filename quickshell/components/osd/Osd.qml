import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../../config/theme.js" as Theme

// Volume / brightness OSD. It only renders - the numbers arrive from the
// services through their `changed` signals.
PanelWindow {
    id: osd

    anchors { top: true; left: true }
    implicitWidth: 360
    implicitHeight: 80
    color: "transparent"
    visible: shown

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusiveZone: -1
    WlrLayershell.namespace: "osd"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    // required so they are set before the Connections below are created
    required property var volume      // services/audio/Volume.qml
    required property var brightness  // services/display/Brightness.qml

    property bool shown: false
    property string kind: "volume"   // volume | brightness
    property real level: 0           // 0..1
    property bool muted: false

    function show(k, v, m) {
        kind = k
        level = Math.max(0, Math.min(1, v))
        if (m !== undefined) muted = m
        shown = true
        hideTimer.restart()
    }

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: osd.shown = false
    }

    Connections {
        target: osd.volume
        function onChanged(level, muted) { osd.show("volume", level, muted) }
    }

    Connections {
        target: osd.brightness
        function onChanged(pct) { osd.show("brightness", pct / 100) }
    }

    Rectangle {
        id: bubble
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 8
        width: 300
        height: 32
        radius: 12
        color: Theme.bg
        opacity: osd.shown ? 1 : 0
        visible: opacity > 0

        Behavior on opacity {
            NumberAnimation { duration: 120 }
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            anchors.topMargin: 2
            anchors.bottomMargin: 4
            spacing: 10

            Text {
                text: osd.kind === "volume"
                    ? (osd.muted ? "󰝟" : (osd.level > 0.66 ? "󰕾" : (osd.level > 0.33 ? "󰝚" : "󰉦")))
                    : "󰃠"
                color: (osd.kind === "volume" && osd.muted) ? Theme.textMuted : Theme.accent
                font.family: Theme.textFont
                font.pixelSize: 20
            }

            Rectangle {   // progress track
                Layout.fillWidth: true
                height: 12
                radius: 10
                color: Theme.bgItem

                Rectangle {
                    width: parent.width * osd.level
                    height: parent.height
                    radius: parent.radius
                    color: osd.muted ? Theme.textMuted : Theme.accent

                    Behavior on width {
                        NumberAnimation { duration: 100 }
                    }
                }
            }

            Text {
                text: Math.round(osd.level * 100) + "%"
                color: Theme.textPrimary
                font.family: Theme.textFont
                font.pixelSize: Theme.pixelSize
            }
        }
    }
}
