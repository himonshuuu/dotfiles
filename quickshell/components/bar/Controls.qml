import QtQuick
import Quickshell
import "../../config/theme.js" as Theme

// Right island: status cells then the power button, every cell on the same 20px line.
Rectangle {
    id: pill

    implicitHeight: 30
    implicitWidth: row.implicitWidth + 20
    radius: Theme.radiusOuter
    color: Theme.bg

    required property var battery
    required property var bluetooth
    property var toggleNotif: function() {}
    property var openPowerMenu: function() {}

    readonly property int cell: 20

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 6

        Item {
            width: pill.cell
            height: pill.cell

            Text {
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
                onClicked: pill.toggleNotif()
            }
        }

        Item {
            width: pill.cell
            height: pill.cell

            Image {
                anchors.centerIn: parent
                width: 14
                height: 14
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
                onClicked: pill.bluetooth.togglePanel()
            }
        }

        Item {
            width: battRow.implicitWidth
            height: pill.cell
            visible: pill.battery.ready

            Row {
                id: battRow
                anchors.centerIn: parent
                spacing: 4

                Text {
                    text: pill.battery.glyph
                    color: pill.battery.charging ? Theme.accent : Theme.textMuted
                    font.family: Theme.textFont
                    font.pixelSize: Theme.pixelSize
                }
                Text {
                    text: pill.battery.percentage + "%"
                    color: Theme.textPrimary
                    font.family: Theme.textFont
                    font.pixelSize: Theme.pixelSize
                }
            }
        }

        Item {
            width: 6
            height: pill.cell

            Text {
                anchors.centerIn: parent
                text: "•"
                color: Theme.textMuted
                font.family: Theme.textFont
                font.pixelSize: Theme.pixelSize
            }
        }

        Rectangle {
            width: pill.cell
            height: pill.cell
            radius: 6
            color: powerMouse.containsMouse ? Theme.activeBg : Theme.bgItem

            Text {
                anchors.centerIn: parent
                text: "󰐥"
                color: Theme.textPrimary
                font.family: Theme.textFont
                font.pixelSize: Theme.pixelSize
            }
            MouseArea {
                id: powerMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: pill.openPowerMenu()
            }
        }
    }
}
