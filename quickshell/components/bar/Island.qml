import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "../../config/theme.js" as Theme

// The island: player, clock, date, apps, bell, bluetooth, battery. Presentation only.
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

    Rectangle {
        id: island
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 6
        radius: Theme.radiusOuter
        color: Theme.bg
        implicitHeight: 30
        implicitWidth: row.implicitWidth + 20

        RowLayout {
            id: row
            anchors.centerIn: parent
            spacing: 10

            // player info (MPRIS)
            Item {
                id: mediaBox
                implicitWidth: mediaRow.implicitWidth
                implicitHeight: mediaRow.implicitHeight
                visible: win.media.label !== ""

                Row {
                    id: mediaRow
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 5
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: win.media.playing ? "󰎈" : "󰏤"
                        color: Theme.accent; font.family: Theme.textFont; font.pixelSize: Theme.pixelSize
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: win.media.label
                        color: Theme.textPrimary; font.family: Theme.textFont; font.pixelSize: Theme.pixelSize
                        elide: Text.ElideRight
                        width: Math.min(implicitWidth, 340)
                    }
                }

                // left = play/pause, middle = previous, right = next
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                    onClicked: function(mouse) {
                        const p = win.media.player
                        if (!p) return
                        if (mouse.button === Qt.LeftButton) {
                            p.isPlaying ? p.pause() : p.play()
                        } else if (mouse.button === Qt.MiddleButton) {
                            if (p.canGoPrevious) p.previous()
                        } else if (mouse.button === Qt.RightButton) {
                            if (p.canGoNext) p.next()
                        }
                    }
                }
            }
            Text { text: "•"; color: Theme.textMuted; visible: win.media.label !== "" }

            Text { id: clock; color: Theme.textPrimary; font.pixelSize: Theme.pixelSize; font.family: Theme.textFont }
            Text { text: "•"; color: Theme.textMuted }
            Text { id: date; color: Theme.textPrimary; font.pixelSize: Theme.pixelSize; font.family: Theme.textFont }
            Text { text: "•"; color: Theme.textMuted }

            Row {
                spacing: 6
                Repeater {
                    model: win.apps.list
                    delegate: Rectangle {
                        required property var modelData
                        width: 24; height: 24; radius: 6
                        color: modelData.activated ? Theme.activeBg : (mouse.containsMouse ? Theme.bgItemHover : Theme.bgItem)

                        readonly property string iconUrl: Quickshell.iconPath(modelData.icon, true)

                        Image {
                            anchors.centerIn: parent
                            width: 18; height: 18
                            source: parent.iconUrl
                            asynchronous: true
                            visible: source !== ""
                        }
                        Text {
                            anchors.centerIn: parent
                            text: (modelData.cls || "?")[0]
                            color: Theme.textPrimary; font.bold: true; font.pixelSize: 12
                            visible: parent.iconUrl === ""
                        }

                        MouseArea {
                            id: mouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                const tl = modelData.tl
                                let addr = tl?.lastIpcObject?.address
                                if (!addr || addr === "0") addr = (tl?.address ? "0x" + tl.address : "")
                                if (addr && addr !== "0x0") {
                                    Hyprland.dispatch('hl.dsp.focus({ window = "address:' + addr + '" })')
                                } else {
                                    const cls = tl?.lastIpcObject?.class
                                    if (cls) Hyprland.dispatch('hl.dsp.focus({ window = "class:' + cls + '" })')
                                }
                            }
                        }
                    }
                }
            }

            // notification viewer toggle
            Text { text: "•"; color: Theme.textMuted }
            Item {
                id: bellBox
                implicitWidth: bellText.implicitWidth
                implicitHeight: bellText.implicitHeight

                Text {
                    id: bellText
                    anchors.centerIn: parent
                    text: "󰂚"
                    color: bellMouse.containsMouse ? Theme.textPrimary : Theme.textMuted
                    font.family: Theme.textFont
                    font.pixelSize: Theme.pixelSize
                }
                MouseArea {
                    id: bellMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: win.toggleNotif()
                }
            }

            // bluetooth panel toggle
            Text { text: "•"; color: Theme.textMuted }
            Item {
                id: btBox
                width: 16
                height: 16

                Image {
                    id: btIcon
                    anchors.fill: parent
                    // generic theme lookup, no per-app overrides
                    source: Quickshell.iconPath("bluetooth", true)
                    asynchronous: true
                    fillMode: Image.PreserveAspectFit
                    opacity: btMouse.containsMouse ? 1.0 : 0.75
                }
                MouseArea {
                    id: btMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: win.bluetooth.togglePanel()
                }
            }

            // battery status (end of island)
            Text { text: "•"; color: Theme.textMuted; visible: win.battery.ready }
            Row {
                spacing: 5
                visible: win.battery.ready
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: win.battery.glyph
                    color: win.battery.charging ? Theme.accent : Theme.textMuted
                    font.family: Theme.textFont; font.pixelSize: Theme.pixelSize
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: win.battery.percentage + "%"
                    color: Theme.textPrimary; font.family: Theme.textFont; font.pixelSize: Theme.pixelSize
                }
            }
        }
    }

    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: {
            clock.text = Qt.formatDateTime(new Date(), "HH:mm:ss")
            date.text = Qt.formatDateTime(new Date(), "ddd, dd MMM yyyy")
        }
    }
}
