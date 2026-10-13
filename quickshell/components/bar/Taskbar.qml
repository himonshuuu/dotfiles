import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../../config/theme.js" as Theme

// Left island: running windows, click to focus.
Rectangle {
    id: pill

    implicitHeight: 30
    implicitWidth: row.implicitWidth + 12
    radius: Theme.radiusOuter
    color: Theme.bg
    visible: row.implicitWidth > 0

    required property var apps

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 6

        Repeater {
            model: pill.apps.list
            delegate: Rectangle {
                required property var modelData
                width: 24; height: 24; 
                // color: modelData.activated ? Theme.activeBg : (mouse.containsMouse ? Theme.bgItemHover : Theme.bgItem)
                color: "transparent"

                readonly property string iconUrl: Quickshell.iconPath(modelData.icon, true)

                Image {
                    anchors.centerIn: parent
                    width: 18; height: 18
                    source: parent.iconUrl
                    asynchronous: true
                    visible: source !== ""
                }
                // Text {
                //     anchors.centerIn: parent
                //     text: (modelData.cls || "?")[0]
                //     color: Theme.textPrimary; font.bold: true; font.pixelSize: 12
                //     visible: parent.iconUrl === ""
                // }

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
}
