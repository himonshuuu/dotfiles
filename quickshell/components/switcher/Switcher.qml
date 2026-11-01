import QtQuick
import Quickshell
import Quickshell.Wayland
import "../../config/theme.js" as Theme

// SUPER+Tab window switcher popup - one card per window in MRU ring order.
PanelWindow {
    id: win

    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    visible: sw.isOpen

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "switcher"
    WlrLayershell.exclusiveZone: -1
    WlrLayershell.keyboardFocus: sw.isOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    // services/switcher/Switcher
    required property var sw

    readonly property int cardW: 148
    readonly property int cardH: 132
    readonly property int perRow: Math.min(Math.max(sw.cycle.length, 1), 6)
    readonly property int rows: Math.ceil(Math.max(sw.cycle.length, 1) / perRow)

    // click anywhere but a card -> cancel
    MouseArea {
        anchors.fill: parent
        onClicked: sw.close()
    }

    Rectangle {
        id: panel
        anchors.centerIn: parent
        width: row.implicitWidth + 32
        height: row.implicitHeight + 32
        radius: Theme.radiusOuter
        color: Theme.bg

        // swallows clicks on the panel chrome so they never reach the cancel area
        MouseArea {
            anchors.fill: parent
        }

        Flow {
            id: row
            anchors.centerIn: parent
            width: win.perRow * (win.cardW + 8) - 8
            spacing: 8

            Repeater {
                model: sw.isOpen ? sw.cycle : []

                delegate: Rectangle {
                    required property int index
                    required property var modelData

                    width: win.cardW
                    height: win.cardH
                    radius: 10
                    color: index === sw.index
                        ? Theme.activeBg
                        : (mouse.containsMouse ? Theme.bgItemHover : "transparent")

                    Behavior on color { ColorAnimation { duration: 120 } }

                    Column {
                        anchors.centerIn: parent
                        width: parent.width - 16
                        spacing: 10

                        Image {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 44
                            height: 44
                            fillMode: Image.PreserveAspectFit
                            asynchronous: true
                            source: modelData.icon ? Quickshell.iconPath(modelData.icon, true) : ""
                        }

                        Text {
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                            text: modelData.title || modelData.cls || "?"
                            color: index === sw.index ? Theme.textPrimary : Theme.textMuted
                            elide: Text.ElideRight
                            maximumLineCount: 2
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            font.family: Theme.textFont
                            font.pixelSize: 11
                        }
                    }

                    MouseArea {
                        id: mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onContainsMouseChanged: {
                            if (mouse.containsMouse) sw.index = parent.index
                        }
                        onClicked: {
                            sw.index = parent.index
                            sw.confirm()
                        }
                    }
                }
            }
        }
    }

    // Escape cancels, Enter confirms, arrows / bare Tab also cycle.
    // SUPER release confirms via the input.keyboard.key handler in
    // hypr/keybinds.lua (layer-shell focus doesn't deliver modifier
    // releases to Keys here); the Super branch below is a harmless fallback.
    Item {
        id: keySink
        focus: win.visible

        onVisibleChanged: {
            if (win.visible) Qt.callLater(function() { keySink.forceActiveFocus() })
        }

        Keys.onReleased: function(event) {
            if (event.key === Qt.Key_Super_L || event.key === Qt.Key_Super_R) {
                sw.confirm(); event.accepted = true
            }
        }

        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Escape) {
                sw.close(); event.accepted = true
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                sw.confirm(); event.accepted = true
            } else if (event.key === Qt.Key_Right || event.key === Qt.Key_Tab) {
                sw.next(); event.accepted = true
            } else if (event.key === Qt.Key_Left || event.key === Qt.Key_Backtab) {
                sw.prev(); event.accepted = true
            }
        }
    }
}
