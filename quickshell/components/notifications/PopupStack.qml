import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import "../../config/theme.js" as Theme
import "../../utils/icons.js" as Icons

// Transient popups, top-right (same spot mako used). Mapped only while showing.
PanelWindow {
    id: win

    anchors { top: true; right: true }
    implicitWidth: 380
    implicitHeight: stack.implicitHeight + 16
    color: "transparent"

    // Notification objects to show (NotificationCenter.popups)
    property var notifications: []
    // extra gap from the right edge, so the popups can clear the viewer panel
    property int rightGap: 0

    visible: notifications.length > 0

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "notifpopup"
    WlrLayershell.exclusiveZone: -1
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.margins.right: rightGap

    // themed-icon lookup stays here: Quickshell.iconPath is only reachable
    // from QML, so utils/icons.js hands this function back and forth
    function themed(name) { return Quickshell.iconPath(name, true); }

    Column {
        id: stack
        anchors { top: parent.top; right: parent.right }
        anchors.margins: 8
        width: win.implicitWidth - 16
        spacing: 8

        Repeater {
            model: win.notifications

            delegate: Rectangle {
                id: card
                required property var modelData

                readonly property var n: modelData
                readonly property bool isCritical:
                    NotificationUrgency.toString(modelData.urgency) === "Critical"
                readonly property string picture: Icons.picture(modelData.image)
                // a real picture gets the big preview, so drop the little tile
                readonly property string iconPath: card.picture === ""
                    ? Icons.resolve(modelData.image, modelData.appIcon, win.themed)
                    : ""

                width: stack.width
                height: content.implicitHeight + 20
                radius: Theme.radiusOuter
                color: Theme.bg
                clip: true

                opacity: 0
                Component.onCompleted: opacity = 1
                Behavior on opacity { NumberAnimation { duration: 180 } }

                // left = default action (or plain dismiss), right = dismiss
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: function(mouse) {
                        if (mouse.button === Qt.RightButton
                                || card.n.actions.length === 0) {
                            card.n.dismiss();
                        } else {
                            card.n.actions[0].invoke();
                        }
                    }
                }

                Rectangle {   // critical marker
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 4
                    width: 3
                    height: parent.height - 8
                    radius: 2
                    color: Theme.accent
                    visible: card.isCritical
                }

                RowLayout {
                    id: content
                    anchors {
                        left: parent.left
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }
                    spacing: 10

                    Rectangle {
                        visible: card.iconPath !== ""
                        width: 30
                        height: 30
                        radius: 7
                        color: Theme.bgItem

                        Image {
                            anchors.centerIn: parent
                            width: 18
                            height: 18
                            source: card.iconPath
                            fillMode: Image.PreserveAspectFit
                            asynchronous: true
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 3

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6

                            Text {
                                Layout.fillWidth: true
                                text: card.n.appName
                                color: Theme.textMuted
                                font.family: Theme.textFont
                                font.pixelSize: 11
                                elide: Text.ElideRight
                            }
                            Text {
                                visible: card.isCritical
                                text: "critical"
                                color: Theme.accent
                                font.family: Theme.textFont
                                font.pixelSize: 10
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            text: card.n.summary
                            color: Theme.textPrimary
                            font.family: Theme.textFont
                            font.pixelSize: Theme.pixelSize
                            font.bold: true
                            elide: Text.ElideRight
                        }

                        Text {
                            Layout.fillWidth: true
                            visible: card.n.body !== ""
                            text: card.n.body
                            color: Theme.textMuted
                            font.family: Theme.textFont
                            font.pixelSize: 11
                            wrapMode: Text.Wrap
                            maximumLineCount: 3
                            elide: Text.ElideRight
                        }

                        Image {   // screenshot / inline image preview
                            Layout.fillWidth: true
                            Layout.preferredHeight: visible ? 110 : 0
                            visible: card.picture !== ""
                            source: card.picture
                            fillMode: Image.PreserveAspectFit
                            asynchronous: true
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            visible: card.n.actions.length > 0

                            Repeater {
                                model: card.n.actions

                                delegate: Rectangle {
                                    id: actBtn
                                    required property var modelData

                                    width: actLabel.implicitWidth + 16
                                    height: 22
                                    radius: 6
                                    color: actMouse.containsMouse
                                        ? Theme.activeBg : Theme.bgItem

                                    Text {
                                        id: actLabel
                                        anchors.centerIn: parent
                                        text: actBtn.modelData.text
                                        color: Theme.textPrimary
                                        font.family: Theme.textFont
                                        font.pixelSize: 11
                                    }
                                    MouseArea {
                                        id: actMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: actBtn.modelData.invoke()
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        width: 24
                        height: 24
                        radius: 6
                        color: closeArea.containsMouse ? Theme.bgItem : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: "✕"
                            color: Theme.textMuted
                            font.pixelSize: 11
                        }
                        MouseArea {
                            id: closeArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: card.n.dismiss()
                        }
                    }
                }
            }
        }
    }
}
