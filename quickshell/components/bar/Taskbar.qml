import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../../config/theme.js" as Theme

// Left island: one group per workspace - every app icon it holds, or a dashed tile when empty.
Rectangle {
    id: pill

    implicitHeight: 30
    implicitWidth: row.implicitWidth + 20
    radius: Theme.radiusOuter
    color: Theme.bg

    required property var apps

    // slots kept even when those workspaces don't exist yet
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
        return Object.keys(ids).map(Number).sort((a, b) => a - b).map(id => ({
            id: id,
            active: id === focused,
            icons: (wins[id] || []).map(e => ({ icon: e.icon, cls: e.cls }))
        }))
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 10

        Repeater {
            model: pill.slots

            delegate: Item {
                id: slot
                required property var modelData

                readonly property bool isEmpty: modelData.icons.length === 0
                implicitWidth: slot.isEmpty ? 24 : iconRow.implicitWidth
                implicitHeight: 24

                Row {
                    id: iconRow
                    visible: !slot.isEmpty
                    spacing: 4

                    Repeater {
                        model: slot.modelData.icons

                        delegate: Item {
                            required property var modelData
                            width: 20
                            height: 24
                            // no tile behind icons - focus is carried by the opacity
                            opacity: slot.modelData.active ? 1 : 0.55

                            readonly property string iconUrl: modelData.icon ? Quickshell.iconPath(modelData.icon, true) : ""

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
                        }
                    }
                }

                Rectangle {
                    visible: slot.isEmpty
                    anchors.fill: parent
                    radius: 6
                    color: slot.modelData.active ? Theme.activeBg
                        : (mouse.containsMouse ? Theme.bgItemHover : Theme.bgItem)

                    Text {
                        anchors.centerIn: parent
                        text: "-"
                        color: Theme.textMuted
                        font.family: Theme.textFont
                        font.pixelSize: Theme.pixelSize
                    }
                }

                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hyprland.dispatch('hl.dsp.focus({ workspace = ' + slot.modelData.id + ' })')
                }
            }
        }
    }
}
