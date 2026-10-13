import QtQuick
import "../../config/theme.js" as Theme

// Center island: clock, date, current media (MPRIS).
Rectangle {
    id: pill

    implicitHeight: 30
    implicitWidth: row.implicitWidth + 20
    radius: Theme.radiusOuter
    color: Theme.bg

    required property var media

    Timer {
        interval: 1000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: {
            clock.text = Qt.formatDateTime(new Date(), "HH:mm:ss")
            date.text = Qt.formatDateTime(new Date(), "ddd, dd MMM yyyy")
        }
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 10

        Text { id: clock; color: Theme.textPrimary; font.pixelSize: Theme.pixelSize; font.family: Theme.textFont }
        Text { text: "•"; color: Theme.textMuted }
        Text { id: date; color: Theme.textPrimary; font.pixelSize: Theme.pixelSize; font.family: Theme.textFont }
        Text { text: "•"; color: Theme.textMuted; visible: pill.media.label !== "" }

        Item {
            id: mediaBox
            implicitWidth: mediaRow.implicitWidth
            implicitHeight: mediaRow.implicitHeight
            visible: pill.media.label !== ""

            Row {
                id: mediaRow
                anchors.verticalCenter: parent.verticalCenter
                spacing: 5
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: pill.media.playing ? "󰎈" : "󰏤"
                    color: Theme.accent; font.family: Theme.textFont; font.pixelSize: Theme.pixelSize
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: pill.media.label
                    color: Theme.textPrimary; font.family: Theme.textFont; font.pixelSize: Theme.pixelSize
                    elide: Text.ElideRight
                    width: Math.min(implicitWidth, 340)
                }
            }

            // left = play/pause, middle = previous, right = next
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                onClicked: function(mouse) {
                    const p = pill.media.player
                    if (!p) return
                    if (mouse.button === Qt.LeftButton) {
                        p.isPlaying ? p.pause() : p.play()
                    } else if (mouse.button === Qt.MiddleButton) {
                        if (p.canGoPrevious) p.previous()
                    } else if (mouse.button === Qt.RightButton) {
                        if (p.canGoNext) p.next()
                    }
                }
            }
        }
    }
}
