import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "../../config/theme.js" as Theme

// Power menu (SUPER+M) - lock / log out / restart / shut down. Session.qml owns the actions.
PanelWindow {
    id: win

    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    visible: win.isOpen

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "powermenu"
    WlrLayershell.exclusiveZone: -1
    WlrLayershell.keyboardFocus: win.isOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    // services/power/Session.qml - lock/logout/reboot/poweroff
    required property var session

    property bool isOpen: false
    property int selected: 0

    IpcHandler {
        target: "powermenu"
        function toggle(): void { win.toggle() }
        function open(): void { win.open() }
        function hide(): void { win.close() }
    }

    function open() {
        win.selected = 0
        win.isOpen = true
        Qt.callLater(function() { keys.forceActiveFocus() })
    }

    function close() { win.isOpen = false }

    function toggle() { win.isOpen ? win.close() : win.open() }

    function run(index) {
        win.close()
        if (index === 0) win.session.lock()
        else if (index === 1) win.session.logout()
        else if (index === 2) win.session.reboot()
        else if (index === 3) win.session.poweroff()
    }

    // there is no text field here, so the window owns the key handling
    Item {
        id: keys
        anchors.fill: parent
        focus: win.isOpen

        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Right) {
                win.selected = (win.selected + 1) % 4; event.accepted = true
            } else if (event.key === Qt.Key_Left) {
                win.selected = (win.selected + 3) % 4; event.accepted = true
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                win.run(win.selected); event.accepted = true
            } else if (event.key === Qt.Key_Escape) {
                win.close(); event.accepted = true
            } else if (event.key >= Qt.Key_1 && event.key <= Qt.Key_4) {
                win.run(event.key - Qt.Key_1); event.accepted = true
            }
        }
    }

    // ------------------------------------------------------------------ view
    Rectangle {
        anchors.fill: parent
        color: Theme.bg
        opacity: 0.55
    }

    MouseArea {
        anchors.fill: parent
        onClicked: win.close()
    }

    Rectangle {
        id: panel
        anchors.centerIn: parent
        width: 440
        height: 184
        radius: Theme.radiusOuter
        color: Theme.bg

        // swallows clicks on the panel chrome so they never reach the
        // "click outside to close" area behind it
        MouseArea {
            anchors.fill: parent
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 22
            spacing: 14

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 20

                Repeater {
                    model: [
                        { glyph: "󰌾", label: "Lock" },
                        { glyph: "󰍃", label: "Log out" },
                        { glyph: "󰜉", label: "Restart" },
                        { glyph: "󰐥", label: "Shut down" }
                    ]

                    delegate: Item {
                        id: cell
                        required property int index
                        required property var modelData

                        Layout.preferredWidth: 84
                        Layout.preferredHeight: 110

                        Rectangle {
                            id: box
                            anchors.top: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 84
                            height: 84
                            radius: Theme.radiusOuter
                            color: cell.index === win.selected
                                ? Theme.activeBg
                                : (cellMouse.containsMouse ? Theme.bgItemHover : Theme.bgItem)

                            Text {
                                anchors.centerIn: parent
                                text: cell.modelData.glyph
                                color: Theme.textPrimary
                                font.family: Theme.textFont
                                font.pixelSize: 28
                            }
                        }

                        Text {
                            anchors.top: box.bottom
                            anchors.topMargin: 7
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: cell.modelData.label
                            color: cell.index === win.selected ? Theme.textPrimary : Theme.textMuted
                            font.family: Theme.textFont
                            font.pixelSize: Theme.pixelSize
                        }

                        MouseArea {
                            id: cellMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onContainsMouseChanged: {
                                if (cellMouse.containsMouse) win.selected = cell.index
                            }
                            onClicked: win.run(cell.index)
                        }
                    }
                }
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "1-4 / Enter to confirm  ·  Esc to cancel"
                color: Theme.textMuted
                font.family: Theme.textFont
                font.pixelSize: Theme.pixelSize
            }
        }
    }
}
