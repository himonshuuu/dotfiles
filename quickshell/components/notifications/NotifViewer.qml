import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "../../config/theme.js" as Theme
import "../../utils/icons.js" as Icons

// Notification history panel (slides in from the right); rows come off NotificationCenter.items.
PanelWindow {
    id: win

    anchors { top: true; bottom: true; right: true }
    implicitWidth: 400
    color: "transparent"

    // NotificationCenter - gives us items / activeCount and performs the
    // dismiss / invoke calls for us.
    property var center

    property bool isOpen: false
    readonly property int closedX: 400
    readonly property int panelW: 392

    // Only occupy the screen while the panel is actually on screen, otherwise a
    // transparent surface would swallow clicks along the right edge.
    visible: win.isOpen || panel.x < win.closedX

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "notifviewer"
    WlrLayershell.exclusiveZone: -1

    IpcHandler {
        target: "notifviewer"
        function toggle(): void { win.isOpen = !win.isOpen }
        function open(): void { win.isOpen = true }
        function hide(): void { win.isOpen = false }
    }

    // themed-icon lookup stays here: Quickshell.iconPath is only reachable
    // from QML, so utils/icons.js hands this function back and forth
    function themed(name) { return Quickshell.iconPath(name, true); }

    // ------------------------------------------------------------------ view
    Rectangle {
        id: panel
        width: win.panelW
        height: parent.height - 16
        x: win.isOpen ? 0 : win.closedX
        y: 8
        radius: Theme.radiusOuter + 4
        color: Theme.bg

        Behavior on x {
            NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 10

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "Notifications"
                    color: Theme.textPrimary
                    font.family: Theme.textFont
                    font.pixelSize: 13
                    font.bold: true
                }
                Text {
                    text: String(win.center ? win.center.items.length : 0)
                    color: Theme.textMuted
                    font.family: Theme.textFont
                    font.pixelSize: Theme.pixelSize
                }
                Item { Layout.fillWidth: true }

                Rectangle {
                    visible: win.center && win.center.activeCount > 0
                    width: clearAllText.implicitWidth + 16
                    height: 22
                    radius: 6
                    color: clearAllMouse.containsMouse ? Theme.bgItem : Theme.bgItemHover

                    Text {
                        id: clearAllText
                        anchors.centerIn: parent
                        text: "Dismiss all"
                        color: Theme.textPrimary
                        font.family: Theme.textFont
                        font.pixelSize: 11
                    }
                    MouseArea {
                        id: clearAllMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: win.center.dismissAll()
                    }
                }

                Rectangle {
                    width: 22
                    height: 22
                    radius: 6
                    color: closeMouse.containsMouse ? Theme.bgItem : Theme.bgItemHover

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: Theme.textPrimary
                        font.pixelSize: 11
                    }
                    MouseArea {
                        id: closeMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: win.isOpen = false
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Theme.border
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ListView {
                    id: list
                    anchors.fill: parent
                    clip: true
                    spacing: 4
                    model: win.center ? win.center.items : []
                    boundsBehavior: Flickable.StopAtBounds

                    delegate: Rectangle {
                        id: row
                        required property var modelData

                        width: list.width
                        height: rowContent.implicitHeight + 16
                        radius: 8
                        color: rowMouse.containsMouse ? Theme.bgItemHover : "transparent"

                        property bool isCritical: modelData.urgency === "critical"
                        property bool isLive: modelData.active === true

                        property string iconPath: Icons.resolve(
                            row.modelData.image, row.modelData.icon, win.themed)

                        MouseArea {
                            id: rowMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            acceptedButtons: Qt.NoButton
                        }

                        // "live" marker: still on screen / urgent
                        Rectangle {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.margins: 4
                            width: 3
                            height: parent.height - 8
                            radius: 2
                            color: Theme.accent
                            visible: row.isLive || row.isCritical
                        }

                        RowLayout {
                            id: rowContent
                            anchors {
                                left: parent.left
                                right: parent.right
                                verticalCenter: parent.verticalCenter
                            }
                            anchors.margins: 10
                            spacing: 10

                            Rectangle {
                                width: 30
                                height: 30
                                radius: 7
                                color: Theme.bgItem

                                Image {
                                    anchors.centerIn: parent
                                    width: 18
                                    height: 18
                                    source: row.iconPath
                                    fillMode: Image.PreserveAspectFit
                                    asynchronous: true
                                    visible: source.toString().length > 0
                                }
                                Text {
                                    anchors.centerIn: parent
                                    visible: row.iconPath === ""
                                    text: (row.modelData.app || "?").charAt(0).toUpperCase()
                                    color: Theme.textPrimary
                                    font.bold: true
                                    font.pixelSize: 12
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 6

                                    Text {
                                        Layout.fillWidth: true
                                        text: row.modelData.app
                                        color: Theme.textMuted
                                        font.family: Theme.textFont
                                        font.pixelSize: 11
                                        elide: Text.ElideRight
                                    }
                                    Text {
                                        visible: row.isCritical
                                        text: "critical"
                                        color: Theme.accent
                                        font.family: Theme.textFont
                                        font.pixelSize: 10
                                    }
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: row.modelData.summary
                                    color: Theme.textPrimary
                                    font.family: Theme.textFont
                                    font.pixelSize: Theme.pixelSize
                                    font.bold: true
                                    elide: Text.ElideRight
                                }

                                Text {
                                    Layout.fillWidth: true
                                    visible: row.modelData.body !== ""
                                    text: row.modelData.body
                                    color: Theme.textMuted
                                    font.family: Theme.textFont
                                    font.pixelSize: 11
                                    wrapMode: Text.Wrap
                                    maximumLineCount: 3
                                    elide: Text.ElideRight
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 6
                                    visible: row.isLive && row.modelData.actionList.length > 0

                                    Repeater {
                                        model: row.modelData.actionList
                                        delegate: Rectangle {
                                            id: actBtn
                                            required property var modelData

                                            width: actLabel.implicitWidth + 16
                                            height: 22
                                            radius: 6
                                            color: actMouse.containsMouse ? Theme.activeBg : Theme.bgItem

                                            Text {
                                                id: actLabel
                                                anchors.centerIn: parent
                                                text: actBtn.modelData.label
                                                color: Theme.textPrimary
                                                font.family: Theme.textFont
                                                font.pixelSize: 11
                                            }
                                            MouseArea {
                                                id: actMouse
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: win.center.invoke(
                                                    row.modelData, actBtn.modelData.index)
                                            }
                                        }
                                    }
                                }
                            }

                            Rectangle {
                                visible: row.isLive
                                width: 24
                                height: 24
                                radius: 6
                                color: dismissMouse.containsMouse ? Theme.bgItem : "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    text: "✕"
                                    color: Theme.textMuted
                                    font.pixelSize: 11
                                }
                                MouseArea {
                                    id: dismissMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: win.center.dismiss(row.modelData)
                                }
                            }
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    visible: !win.center || win.center.items.length === 0
                    text: "No notifications"
                    color: Theme.textMuted
                    font.family: Theme.textFont
                    font.pixelSize: Theme.pixelSize
                }
            }
        }
    }
}
