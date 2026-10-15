import QtQuick
import "../../config/theme.js" as Theme

// Mic / speaker / screen-share activity island; each glyph toggles its side.
Rectangle {
    id: pill

    implicitHeight: 30
    implicitWidth: row.implicitWidth + 20
    radius: Theme.radiusOuter
    color: Theme.bg

    required property var activity

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 10

        Text {
            id: micGlyph
            anchors.verticalCenter: parent.verticalCenter
            text: pill.activity.micMuted ? "" : ""
            color: pill.activity.micMuted ? Theme.hot
                 : pill.activity.speaking ? Theme.hot
                 : pill.activity.micOpen ? Theme.textPrimary
                 : Theme.textMuted
            font.family: Theme.textFont
            font.pixelSize: Theme.pixelSize + 12

            MouseArea {
                anchors.fill: parent
                anchors.margins: -4
                cursorShape: Qt.PointingHandCursor
                onClicked: pill.activity.toggleMic()
            }
        }
        Text {
            id: spkGlyph
            anchors.verticalCenter: parent.verticalCenter
            text: pill.activity.speakerMuted ? "󰝟" : ""
            color: pill.activity.speakerMuted ? Theme.hot
                 : pill.activity.sounding ? Theme.hot
                 : pill.activity.speakerOpen ? Theme.textPrimary
                 : Theme.textMuted
            font.family: Theme.textFont
            font.pixelSize: Theme.pixelSize + 10

            MouseArea {
                anchors.fill: parent
                anchors.margins: -4
                cursorShape: Qt.PointingHandCursor
                onClicked: pill.activity.toggleSpeaker()
            }
        }
        Text {
            id: scrGlyph
            anchors.verticalCenter: parent.verticalCenter
            text: pill.activity.privateScreen ? "󰶐" : "󰍹"
            color: pill.activity.privateScreen || pill.activity.capturing ? Theme.hot : Theme.textMuted
            font.family: Theme.textFont
            font.pixelSize: Theme.pixelSize + 8

            MouseArea {
                anchors.fill: parent
                anchors.margins: -4
                cursorShape: Qt.PointingHandCursor
                onClicked: pill.activity.togglePrivate()
            }
        }
    }
}
