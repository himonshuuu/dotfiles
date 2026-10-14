import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../../config/theme.js" as Theme

// Left island: one slot per workspace - app icon when it has windows, dash when empty.
Rectangle {
    id: pill

    implicitHeight: 30
    implicitWidth: row.implicitWidth + 20
    radius: Theme.radiusOuter
    color: Theme.bg
    visible: row.implicitWidth > 0

    required property var apps

    // slots kept visible even when those workspaces don't exist yet
    property int minWorkspaces: 5

    readonly property var slots: {
        const ids = {}
        for (let i = 1; i <= pill.minWorkspaces; i++) ids[i] = true
        for (const w of (Hyprland.workspaces?.values ?? [])) ids[w.id] = true

        const wins = {}
        for (const e of pill.apps.list) {
            const id = e.tl?.workspace?.id
            if (id === undefined || id === null) continue
            (wins[id] = wins[id] || []).push(e)
        }

        const focused = Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : -1
        return Object.keys(ids).map(Number).sort((a, b) => a - b).map(id => {
            const list = wins[id] || []
            const lead = list.find(e => e.activated) || list[0]
            return {
                id: id,
                icon: lead ? lead.icon : "",
                cls: lead ? lead.cls : "",
                active: id === focused
            }
        })
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 6

        Repeater {
            model: pill.slots
            delegate: Rectangle {
                required property var modelData
                width: 24; height: 24; radius: 6
                color: modelData.active ? Theme.activeBg : (mouse.containsMouse ? Theme.bgItemHover : Theme.bgItem)

                readonly property bool occupied: modelData.icon !== ""
                readonly property string iconUrl: occupied ? Quickshell.iconPath(modelData.icon, true) : ""

                Image {
                    anchors.centerIn: parent
                    width: 18; height: 18
                    source: parent.iconUrl
                    asynchronous: true
                    visible: source !== ""
                }
                Text {
                    anchors.centerIn: parent
                    text: parent.occupied ? (modelData.cls || "?")[0] : "-"
                    color: Theme.textPrimary; font.bold: true; font.pixelSize: 12
                    visible: parent.iconUrl === ""
                }

                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hyprland.dispatch('hl.dsp.focus({ workspace = ' + modelData.id + ' })')
                }
            }
        }
    }
}
