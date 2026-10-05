import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../../config/theme.js" as Theme

// polkit auth dialog (pkexec). The agent itself is services/polkit/Agent.qml.
PanelWindow {
    id: win

    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    visible: agent.active && !!agent.flow && !agent.flow.isCompleted

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "polkit"
    WlrLayershell.exclusiveZone: -1
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    // services/polkit/Agent.qml
    required property var agent

    property string password: ""
    property string hint: ""

    // flow is null before the first request, so read off an empty object.
    readonly property var f: agent.flow || ({})

    function submit() {
        if (!agent.prompting) return;
        const pw = password;
        password = "";
        hint = "";
        agent.submit(pw);
    }

    function cancel() {
        password = "";
        agent.cancel();
    }

    function cycleIdentity() {
        const ids = f.identities || [];
        if (ids.length < 2) return;
        const i = ids.indexOf(f.selectedIdentity);
        f.selectedIdentity = ids[(i + 1) % ids.length];
    }

    onVisibleChanged: {
        password = "";
        hint = "";
        if (visible) Qt.callLater(function() { field.forceActiveFocus() });
    }

    // a failed attempt keeps the dialog up (polkitd asks again), so the error
    // is read off the flow rather than assumed to end the conversation
    Connections {
        target: win.agent.flow

        function onAuthenticationFailed() {
            win.password = "";
            win.hint = "Authentication failed";
        }
        function onAuthenticationRequestCancelled() {
            win.password = "";
            win.hint = "";
        }
    }

    // ------------------------------------------------------------------ keys
    Item {
        anchors.fill: parent
        focus: win.visible

        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Escape) {
                win.cancel();
                event.accepted = true;
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: win.cancel()
    }

    // ------------------------------------------------------------------ card
    Rectangle {
        id: card
        anchors.centerIn: parent
        width: 430
        height: col.implicitHeight + 52
        radius: Theme.radiusOuter
        color: Theme.bg

        MouseArea {
            // keeps a click on the card from reaching the backdrop
            anchors.fill: parent
            z: -1
        }

        ColumnLayout {
            id: col
            anchors.fill: parent
            anchors.margins: 26
            spacing: 16

            // -------------------------------------------------------- header
            RowLayout {
                Layout.fillWidth: true
                spacing: 14

                Image {
                    id: iconImg
                    source: win.f.iconName ? Quickshell.iconPath(String(win.f.iconName), true) : ""
                    width: 36
                    height: 36
                    asynchronous: true
                    fillMode: Image.PreserveAspectFit
                    visible: source.toString() !== ""
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Text {
                        text: String(win.f.message || "")
                        color: Theme.textPrimary
                        font.family: Theme.textFont
                        font.pixelSize: 13
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }

                    Text {
                        text: String(win.f.actionId || "")
                        color: Theme.textMuted
                        font.family: Theme.textFont
                        font.pixelSize: 11
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        visible: text !== ""
                    }
                }
            }

            // account being authenticated - a label, not a field, so it gets
            // no background (otherwise it reads as a second input box)
            Rectangle {
                Layout.fillWidth: true
                height: idText.implicitHeight + 8
                radius: 6
                color: idMouse.containsMouse ? Theme.bgItem : "transparent"
                visible: idText.text !== ""

                Text {
                    id: idText
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: {
                        const id = win.f.selectedIdentity;
                        const who = (id && id.displayName) ? id.displayName : "";
                        const n = (win.f.identities || []).length;
                        return who + (n > 1 ? "   \u203a" : "");
                    }
                    color: Theme.textMuted
                    font.family: Theme.textFont
                    font.pixelSize: 11
                    elide: Text.ElideRight
                }

                MouseArea {
                    id: idMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    enabled: (win.f.identities || []).length > 1
                    onClicked: win.cycleIdentity()
                }
            }

            // ------------------------------------------------------- message
            Text {
                Layout.fillWidth: true
                visible: text !== ""
                text: win.hint !== "" ? win.hint : String(win.f.supplementary || "")
                color: (win.hint !== "" || win.f.supplementaryIsError) ? Theme.accent : Theme.textMuted
                font.family: Theme.textFont
                font.pixelSize: 11
                wrapMode: Text.WordWrap
            }

            // --------------------------------------------------- password box
            Rectangle {
                Layout.fillWidth: true
                height: 38
                radius: 6
                color: Theme.bgItem

                TextInput {
                    id: field
                    anchors.fill: parent
                    anchors.margins: 12
                    verticalAlignment: TextInput.AlignVCenter
                    echoMode: win.f.responseVisible ? TextInput.Normal : TextInput.Password
                    passwordCharacter: "\u2022"
                    color: Theme.textPrimary
                    selectionColor: Theme.accent
                    selectedTextColor: Theme.textPrimary
                    font.family: Theme.textFont
                    font.pixelSize: 15
                    focus: win.visible
                    text: win.password
                    onTextChanged: win.password = text

                    Keys.onPressed: function(event) {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            win.submit();
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Escape) {
                            win.cancel();
                            event.accepted = true;
                        }
                    }
                }
            }

            // ------------------------------------------------------- buttons
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Text {
                    text: "Authentication required"
                    color: Theme.textMuted
                    font.family: Theme.textFont
                    font.pixelSize: 11
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                Rectangle {
                    id: cancelBtn
                    width: cancelText.width + 26
                    height: 30
                    radius: 6
                    color: cancelMouse.containsMouse ? Theme.bgItemHover : Theme.bgItem

                    Text {
                        id: cancelText
                        anchors.centerIn: parent
                        text: "Cancel"
                        color: Theme.textMuted
                        font.family: Theme.textFont
                        font.pixelSize: Theme.pixelSize
                    }
                    MouseArea {
                        id: cancelMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: win.cancel()
                    }
                }

                Rectangle {
                    id: authBtn
                    width: authText.width + 26
                    height: 30
                    radius: 6
                    color: authMouse.containsMouse ? Theme.accent : Theme.activeBg

                    Text {
                        id: authText
                        anchors.centerIn: parent
                        text: "Authenticate"
                        color: Theme.textPrimary
                        font.family: Theme.textFont
                        font.pixelSize: Theme.pixelSize
                    }
                    MouseArea {
                        id: authMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: win.submit()
                    }
                }
            }
        }
    }
}
