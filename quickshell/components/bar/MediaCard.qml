import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import "../../config/theme.js" as Theme

// Hover card for the center player: artwork, times, transport.
PanelWindow {
    id: win

    anchors { top: true; right: true }
    implicitWidth: card.width
    implicitHeight: card.height
    color: "transparent"
    visible: media.open && media.label !== ""

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "mediacard"
    WlrLayershell.exclusiveZone: -1
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.margins.top: 48
    WlrLayershell.margins.right: Math.round((Screen.width - card.width) / 2)

    required property var media

    readonly property var player: media.player
    readonly property real ratio: (player && player.length > 0)
        ? Math.min(1, player.position / player.length) : 0

    function clock(s) {
        const v = Math.max(0, Math.floor(s || 0))
        return Math.floor(v / 60) + ":" + (v % 60 < 10 ? "0" : "") + (v % 60)
    }

    Rectangle {
        id: card
        width: 340
        height: hoverCol.implicitHeight + 24
        radius: Theme.radiusOuter
        color: Theme.bg

        // sits under the controls so a hover keeps the card mapped
        MouseArea {
            id: hoverArea
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            onEntered: win.media.popupEnter()
            onExited: win.media.popupLeave()

            Column {
                id: hoverCol
                anchors { top: parent.top; left: parent.left; right: parent.right }
                anchors.margins: 12
                spacing: 10

                Row {
                    id: head
                    width: parent.width
                    spacing: 12

                    Rectangle {
                        id: art
                        width: 76
                        height: 76
                        radius: 8
                        color: Theme.bgItem

                        Image {
                            id: cover
                            anchors.fill: parent
                            source: win.player ? win.player.trackArtUrl : ""
                            asynchronous: true
                            fillMode: Image.PreserveAspectFill
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                maskEnabled: true
                                maskSource: artMask
                            }
                        }

                        Item {
                            id: artMask
                            anchors.fill: parent
                            visible: false
                            Rectangle { anchors.fill: parent; radius: art.radius; color: "white" }
                        }

                        Image {
                            anchors.centerIn: parent
                            width: 22
                            height: 22
                            source: Quickshell.iconPath("audio-x-generic", true)
                            asynchronous: true
                            visible: cover.status !== Image.Ready
                        }
                    }

                    Column {
                        width: head.width - art.width - play.width - head.spacing * 2
                        spacing: 4

                        Text {
                            width: parent.width
                            text: win.player ? win.player.trackTitle : ""
                            color: Theme.textPrimary
                            font.family: Theme.textFont
                            font.pixelSize: 14
                            font.bold: true
                            elide: Text.ElideRight
                        }
                        Text {
                            width: parent.width
                            text: win.player ? win.player.trackArtist : ""
                            color: Theme.textMuted
                            font.family: Theme.textFont
                            font.pixelSize: Theme.pixelSize
                            elide: Text.ElideRight
                        }
                        Text {
                            width: parent.width
                            text: win.player && win.player.length > 0
                                ? win.clock(win.player.position) + " / " + win.clock(win.player.length)
                                : ""
                            color: Theme.textMuted
                            font.family: Theme.textFont
                            font.pixelSize: Theme.pixelSize
                        }
                    }

                    Rectangle {
                        id: play
                        width: 36
                        height: 36
                        radius: 18
                        color: playMouse.containsMouse ? Theme.bgItemHover : Theme.bgItem

                        Text {
                            anchors.centerIn: parent
                            text: win.media.playing ? "󰏤" : ""
                            color: Theme.textPrimary
                            font.family: Theme.textFont
                            font.pixelSize: 16
                        }
                        MouseArea {
                            id: playMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (!win.player) return
                                if (win.player.isPlaying) win.player.pause()
                                else win.player.play()
                            }
                        }
                    }
                }

                Row {
                    width: parent.width
                    height: 20
                    spacing: 10

                    Item {
                        width: 20
                        height: 20

                        Text {
                            anchors.centerIn: parent
                            text: "󰒮"
                            color: prevMouse.containsMouse ? Theme.textPrimary : Theme.textMuted
                            font.family: Theme.textFont
                            font.pixelSize: 14
                        }
                        MouseArea {
                            id: prevMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: if (win.player && win.player.canGoPrevious) win.player.previous()
                        }
                    }

                    Item {
                        id: track
                        width: parent.width - 60
                        height: 20

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width
                            height: 4
                            radius: 2
                            color: Theme.bgItem
                        }
                        Rectangle {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            width: Math.max(4, parent.width * win.ratio)
                            height: 4
                            radius: 2
                            color: Theme.accent
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: function(mouse) {
                                if (!win.player || win.player.length <= 0) return
                                win.player.position = (mouse.x / track.width) * win.player.length
                            }
                        }
                    }

                    Item {
                        width: 20
                        height: 20

                        Text {
                            anchors.centerIn: parent
                            text: "󰒭"
                            color: nextMouse.containsMouse ? Theme.textPrimary : Theme.textMuted
                            font.family: Theme.textFont
                            font.pixelSize: 14
                        }
                        MouseArea {
                            id: nextMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: if (win.player && win.player.canGoNext) win.player.next()
                        }
                    }
                }
            }
        }
    }
}
