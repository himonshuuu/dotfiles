import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import "../../config/theme.js" as Theme

// App launcher (SUPER+A) - replaces fuzzel; Catalog.qml owns the list and fuzzy match.
PanelWindow {
    id: win

    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    visible: win.isOpen

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "launcher"
    WlrLayershell.exclusiveZone: -1
    WlrLayershell.keyboardFocus: win.isOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    // services/apps/Catalog - gives us results + launch()
    required property var catalog

    property bool isOpen: false
    property int selected: 0

    readonly property var results: catalog.results
    readonly property int rowH: 44
    // grows with the result count, but never taller than 9 rows
    readonly property int rows: Math.min(Math.max(win.results.length, 1), 9)

    IpcHandler {
        target: "launcher"
        function toggle(): void { win.toggle() }
        function open(): void { win.open() }
        function hide(): void { win.close() }
    }

    // ----------------------------------------------------------------- keys
    function open() {
        win.selected = 0
        input.text = ""          // clears catalog.query through onTextChanged
        win.isOpen = true
        Qt.callLater(function() { input.forceActiveFocus() })
    }

    function close() {
        win.isOpen = false
    }

    function toggle() {
        win.isOpen ? win.close() : win.open()
    }

    function move(delta) {
        var n = win.results.length
        if (n === 0) return
        win.selected = (win.selected + delta + n) % n
        list.positionViewAtIndex(win.selected, ListView.Contain)
    }

    function launchSelected() {
        var entry = win.results[win.selected]
        if (!entry) return
        win.close()
        win.catalog.launch(entry)
    }

    // the query shrinks the list under us - keep the highlight on a real row
    onResultsChanged: {
        if (win.results.length === 0)
            win.selected = 0
        else if (win.selected >= win.results.length)
            win.selected = win.results.length - 1
    }

    // ------------------------------------------------------------------ view
    Rectangle {
        anchors.fill: parent
        color: Theme.bg
        opacity: 0.55
    }

    // click anywhere but the panel -> close
    MouseArea {
        anchors.fill: parent
        onClicked: win.close()
    }

    Rectangle {
        id: panel
        anchors.centerIn: parent
        width: 640
        height: 64 + win.rows * win.rowH
        radius: Theme.radiusOuter
        color: Theme.bg

        // swallows clicks on the panel chrome so they never reach the
        // "click outside to close" area behind it
        MouseArea {
            anchors.fill: parent
        }

        ColumnLayout {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 12
            anchors.leftMargin: 14
            anchors.rightMargin: 14
            spacing: 8

            // ------------------------------------------------------- search
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                spacing: 10

                Text {
                    text: "󰍉"
                    color: Theme.accent
                    font.family: Theme.textFont
                    font.pixelSize: 16
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    // placeholder sits under the caret, never over it
                    Text {
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        text: "Search applications"
                        color: Theme.textMuted
                        font.family: Theme.textFont
                        font.pixelSize: 15
                        visible: input.text === ""
                    }

                    TextInput {
                        id: input
                        anchors.fill: parent
                        verticalAlignment: TextInput.AlignVCenter
                        color: Theme.textPrimary
                        selectionColor: Theme.accent
                        selectedTextColor: Theme.textPrimary
                        font.family: Theme.textFont
                        font.pixelSize: 15
                        focus: win.isOpen
                        clip: true

                        onTextChanged: win.catalog.query = text

                        Keys.onPressed: function(event) {
                            if (event.key === Qt.Key_Down) {
                                win.move(1); event.accepted = true
                            } else if (event.key === Qt.Key_Up) {
                                win.move(-1); event.accepted = true
                            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                win.launchSelected(); event.accepted = true
                            } else if (event.key === Qt.Key_Escape) {
                                win.close(); event.accepted = true
                            }
                        }
                    }
                }
            }

            // ------------------------------------------------------ results
            Item {
                id: listArea
                Layout.fillWidth: true
                Layout.preferredHeight: win.rows * win.rowH

                ListView {
                    id: list
                    anchors.fill: parent
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    model: win.results

                    delegate: Rectangle {
                        id: row

                        required property int index
                        required property var modelData

                        width: list.width
                        height: win.rowH
                        radius: 6
                        color: index === win.selected
                            ? Theme.activeBg
                            : (mouse.containsMouse ? Theme.bgItemHover : "transparent")

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            spacing: 10

                            Item {
                                Layout.preferredWidth: 26
                                Layout.preferredHeight: 26

                                Image {
                                    id: appIcon
                                    anchors.fill: parent
                                    fillMode: Image.PreserveAspectFit
                                    asynchronous: true
                                    source: row.modelData.icon
                                        ? Quickshell.iconPath(row.modelData.icon, true) : ""
                                }

                                // same letter fallback the dock tiles use
                                Text {
                                    anchors.centerIn: parent
                                    visible: appIcon.status !== Image.Ready
                                    text: (row.modelData.name || "?").charAt(0).toUpperCase()
                                    color: Theme.textMuted
                                    font.family: Theme.textFont
                                    font.pixelSize: 14
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                                text: row.modelData.name || "?"
                                color: Theme.textPrimary
                                elide: Text.ElideRight
                                font.family: Theme.textFont
                                font.pixelSize: 14
                            }

                            Text {
                                Layout.maximumWidth: 220
                                text: row.modelData.genericName || ""
                                color: Theme.textMuted
                                elide: Text.ElideRight
                                font.family: Theme.textFont
                                font.pixelSize: 12
                                visible: text !== ""
                            }
                        }

                        MouseArea {
                            id: mouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onContainsMouseChanged: {
                                if (mouse.containsMouse) win.selected = row.index
                            }
                            onClicked: {
                                win.selected = row.index
                                win.launchSelected()
                            }
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    visible: win.results.length === 0
                    text: "No matches"
                    color: Theme.textMuted
                    font.family: Theme.textFont
                    font.pixelSize: 13
                }
            }
        }
    }
}
