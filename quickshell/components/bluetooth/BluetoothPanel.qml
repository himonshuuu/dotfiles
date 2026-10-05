import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Bluetooth
import "../../config/theme.js" as Theme

// Bluetooth popover (replaces blueman-manager). Row click acts, right-click forgets.
PanelWindow {
    id: win

    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    visible: bt.open

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "bluetooth"
    WlrLayershell.exclusiveZone: -1
    WlrLayershell.keyboardFocus: bt.open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    // services/bluetooth/Bluetooth.qml
    required property var bt

    // ------------------------------------------------------------------ keys
    Item {
        anchors.fill: parent
        focus: win.visible

        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Escape) {
                win.bt.closePanel();
                event.accepted = true;
            }
        }
    }

    // Click outside closes it; card bounds are checked because a click may come through the card.
    MouseArea {
        anchors.fill: parent
        onClicked: function(mouse) {
            const p = Qt.point(mouse.x - card.x, mouse.y - card.y);
            if (!card.contains(p)) win.bt.closePanel();
        }
    }

    // ------------------------------------------------------------------ card
    Rectangle {
        id: card
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 50
        anchors.rightMargin: 12
        width: 350
        height: Math.min(col.implicitHeight + 26, win.height - 70)
        radius: Theme.radiusOuter
        color: Theme.bg

        MouseArea {
            // keeps a click on the card from reaching the backdrop
            anchors.fill: parent
            z: -1
        }

        ColumnLayout {
            id: col
            anchors.fill: parent
            anchors.margins: 13
            spacing: 10

            // ------------------------------------------------------- header
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Text {
                    text: "Bluetooth"
                    color: Theme.textPrimary
                    font.family: Theme.textFont
                    font.pixelSize: 14
                    font.bold: true
                    Layout.fillWidth: true
                }

                Rectangle {
                    id: track
                    width: 40
                    height: 20
                    radius: 10
                    color: win.bt.powered ? Theme.activeBg : Theme.bgItem

                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        x: win.bt.powered ? parent.width - width - 2 : 2
                        width: 16
                        height: 16
                        radius: 8
                        color: Theme.textPrimary

                        Behavior on x { NumberAnimation { duration: 130 } }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: win.bt.setPowered(!win.bt.powered)
                    }
                }
            }

            // --------------------------------------------------- scan row
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                visible: win.bt.powered

                Text {
                    text: win.bt.adapterName || "No adapter"
                    color: Theme.textMuted
                    font.family: Theme.textFont
                    font.pixelSize: 11
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                Rectangle {
                    id: scanBtn
                    width: scanLabel.width + 18
                    height: 22
                    radius: 6
                    color: scanMouse.containsMouse ? Theme.bgItemHover : Theme.bgItem

                    Text {
                        id: scanLabel
                        anchors.centerIn: parent
                        text: win.bt.scanning ? "Stop scan" : "Scan"
                        color: Theme.textPrimary
                        font.family: Theme.textFont
                        font.pixelSize: 11
                    }

                    MouseArea {
                        id: scanMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: win.bt.toggleScan()
                    }
                }
            }

            // ------------------------------------------------- empty states
            Text {
                visible: !win.bt.powered
                text: "Bluetooth is off"
                color: Theme.textMuted
                font.family: Theme.textFont
                font.pixelSize: Theme.pixelSize
            }

            Text {
                visible: win.bt.powered && win.bt.list.length === 0
                text: win.bt.scanning ? "Looking for devices\u2026"
                                      : "No devices known - press Scan"
                color: Theme.textMuted
                font.family: Theme.textFont
                font.pixelSize: Theme.pixelSize
            }

            // --------------------------------------------------- device list
            ListView {
                id: listView
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(contentHeight, win.height - 220)
                model: win.bt.list
                spacing: 6
                clip: true
                interactive: contentHeight > height
                visible: win.bt.powered && win.bt.list.length > 0

                delegate: Item {
                    id: row
                    required property var modelData
                    width: listView.width
                    // devCol fills this box, so its margins have to be added on
                    height: devCol.implicitHeight + 20

                    // required props go null while the delegate is torn down
                    readonly property var dev: modelData || ({})

                    Rectangle {
                        anchors.fill: parent
                        radius: 8
                        color: devMouse.containsMouse ? Theme.bgItemHover : Theme.bgItem
                    }

                    RowLayout {
                        id: devCol
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        Image {
                            source: Quickshell.iconPath(row.dev.icon || "bluetooth", true)
                            width: 20
                            height: 20
                            asynchronous: true
                            sourceSize.width: 40
                            sourceSize.height: 40
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                text: row.dev.deviceName || row.dev.name || "(unnamed device)"
                                color: Theme.textPrimary
                                font.family: Theme.textFont
                                font.pixelSize: Theme.pixelSize
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            Text {
                                text: statusOf(row.dev)
                                color: row.dev.connected ? Theme.accent : Theme.textMuted
                                font.family: Theme.textFont
                                font.pixelSize: 11
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }

                        Text {
                            text: row.dev.pairing ? "\u2026" : actionOf(row.dev)
                            color: Theme.textMuted
                            font.family: Theme.textFont
                            font.pixelSize: 11
                        }
                    }

                    MouseArea {
                        id: devMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        cursorShape: Qt.PointingHandCursor

                        onClicked: function(mouse) {
                            if (mouse.button === Qt.RightButton) win.bt.forget(row.dev);
                            else win.bt.action(row.dev);
                        }
                    }
                }
            }
        }
    }

    // State wording comes from BlueZ (BluetoothDeviceState.toString); only "pairing" is ours.
    function statusOf(d) {
        if (d.pairing) return "Pairing\u2026";

        var s = BluetoothDeviceState.toString(d.state);
        if (d.batteryAvailable && (d.connected || d.state === BluetoothDeviceState.Connected))
            s += "  \u00b7  " + Math.round(d.battery * 100) + "%";
        else if ((d.paired || d.bonded) && !d.connected)
            s += "  \u00b7  Paired";
        return s;
    }

    function actionOf(d) {
        if (d.connected) return "Disconnect";
        if (d.paired || d.bonded) return "Connect";
        return "Pair";
    }
}
