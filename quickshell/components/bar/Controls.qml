import QtQuick
import Quickshell
import "../../config/theme.js" as Theme

// Right island: bell, bluetooth, battery, power.
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

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 8

        // notification viewer toggle
        Item {
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
                onClicked: pill.toggleNotif()
            }
        }

        // bluetooth panel toggle
        Item {
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
                onClicked: pill.bluetooth.togglePanel()
            }
        }

        // battery status
        Row {
            spacing: 5
            visible: pill.battery.ready
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: pill.battery.glyph
                color: pill.battery.charging ? Theme.accent : Theme.textMuted
                font.family: Theme.textFont; font.pixelSize: Theme.pixelSize
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: pill.battery.percentage + "%"
                color: Theme.textPrimary; font.family: Theme.textFont; font.pixelSize: Theme.pixelSize
            }
        }

        Text { text: "•"; color: Theme.textMuted }

        Rectangle {
            id: powerBox
            width: 24; height: 24; radius: 6
            color: powerMouse.containsMouse ? Theme.activeBg : Theme.bgItem

            Text {
                anchors.centerIn: parent
                text: "󰐥"
                color: Theme.textPrimary
                font.family: Theme.textFont
                font.pixelSize: 14
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
