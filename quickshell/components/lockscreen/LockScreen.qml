import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam
import "../../config/theme.js" as Theme

// Session lock (ext-session-lock-v1). Root is an Item: WlSessionLock's default property is `surface`.
Item {
    id: root

    required property var session   // services/power/Session.qml

    // Hoisted out: ids inside a Component belong to that component's context.
    property string password: ""
    property string hint: ""
    property int retries: 0

    function lockNow() {
        root.password = ""
        root.hint = ""
        root.retries = 0
        lock.locked = true
        Qt.callLater(function() { root.begin() })
    }

    function begin() {
        if (pam.active) return
        if (!pam.start()) {
            root.hint = "Could not start PAM"
            lock.locked = false
        }
    }

    function submit() {
        // responseRequired only goes true while PAM is actually waiting on a
        // reply, so an early Enter is ignored instead of desyncing the chat
        if (!pam.active || !pam.responseRequired) return
        const pw = root.password
        root.password = ""
        pam.respond(pw)
    }

    Connections {
        target: root.session
        function onLockRequested() { root.lockNow() }
    }

    PamContext {
        id: pam
        config: "login"

        onCompleted: function(result) {
            if (result === PamResult.Success) {
                root.password = ""
                root.hint = ""
                root.retries = 0
                lock.locked = false
                return
            }
            root.hint = "Authentication failed"
            root.password = ""
            Qt.callLater(function() { root.begin() })
        }

        onError: function(err) {
            root.hint = PamError.toString(err)
            root.password = ""
            if (++root.retries > 2) { lock.locked = false; return }
            Qt.callLater(function() { root.begin() })
        }
    }

    WlSessionLock {
        id: lock

        surface: Component {
            WlSessionLockSurface {
                color: Theme.bg

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    triggeredOnStart: true
                    onTriggered: clock.text = Qt.formatDateTime(new Date(), "HH:mm")
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 12

                    Text {
                        id: clock
                        Layout.alignment: Qt.AlignHCenter
                        color: Theme.textPrimary
                        font.family: Theme.textFont
                        font.pixelSize: 64
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: Qt.formatDateTime(new Date(), "ddd, dd MMM yyyy")
                        color: Theme.textMuted
                        font.family: Theme.textFont
                        font.pixelSize: Theme.pixelSize
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 14
                        text: root.hint !== "" ? root.hint
                            : (pam.message !== "" ? pam.message : "Password")
                        color: root.hint !== "" ? Theme.accent : Theme.textMuted
                        font.family: Theme.textFont
                        font.pixelSize: Theme.pixelSize
                    }

                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        width: 300
                        height: 38
                        radius: 6
                        color: Theme.bgItem

                        TextInput {
                            id: field
                            anchors.fill: parent
                            anchors.margins: 12
                            verticalAlignment: TextInput.AlignVCenter
                            echoMode: pam.responseVisible ? TextInput.Normal : TextInput.Password
                            passwordCharacter: "•"
                            color: Theme.textPrimary
                            selectionColor: Theme.accent
                            selectedTextColor: Theme.textPrimary
                            font.family: Theme.textFont
                            font.pixelSize: 15
                            focus: true
                            text: root.password
                            onTextChanged: root.password = text

                            Keys.onPressed: function(event) {
                                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                    root.submit(); event.accepted = true
                                } else if (event.key === Qt.Key_Escape) {
                                    event.accepted = true
                                }
                            }
                        }
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 4
                        text: "Enter your password to unlock"
                        color: Theme.textMuted
                        font.family: Theme.textFont
                        font.pixelSize: 11
                    }
                }
            }
        }
    }
}
