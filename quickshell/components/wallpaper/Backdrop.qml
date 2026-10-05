import QtQuick
import Quickshell
import Quickshell.Wayland
import "../../config/theme.js" as Theme

// Wallpaper as a Background layer; Wallpaper.qml owns current/previous, this only draws them.
PanelWindow {
    id: win

    anchors { top: true; bottom: true; left: true; right: true }
    color: Theme.bg    // flat fallback while the first image decodes

    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.namespace: "wallpaper"
    // -1 = ignore other surfaces' exclusive zones, so the island's bar zone
    // doesn't punch a hole in the top of the screen
    WlrLayershell.exclusiveZone: -1

    // services/wallpaper/Wallpaper.qml
    required property var wallpaper

    Image {
        id: under
        anchors.fill: parent
        source: win.wallpaper.previous
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        smooth: true
    }

    Image {
        id: over
        anchors.fill: parent
        source: win.wallpaper.current
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        smooth: true
        opacity: 1

        // the fade must not run ahead of the decoder - if it finished while
        // the file was still loading we'd be left showing `previous`
        property bool fadeQueued: false

        function kick() {
            if (status === Image.Ready) { fadeQueued = false; fadeIn.start(); }
        }

        onStatusChanged: {
            if (fadeQueued && status === Image.Ready) { fadeQueued = false; fadeIn.start(); }
        }
    }

    NumberAnimation {
        id: fadeIn
        target: over
        property: "opacity"
        from: 0
        to: 1
        duration: 500
        easing.type: Easing.InOutQuad
    }

    Connections {
        target: win.wallpaper

        function onCurrentChanged() {
            over.opacity = 0
            over.fadeQueued = true
            // callLater so `over.source` has moved over before we read status
            Qt.callLater(function() { over.kick() })
        }
    }
}
