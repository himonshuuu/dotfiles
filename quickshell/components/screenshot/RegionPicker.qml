import QtQuick
import Quickshell
import Quickshell.Wayland
import "../../config/theme.js" as Theme

// Drag-to-select overlay (replaces slurp -d); four dim rects leave a hole over the selection.
PanelWindow {
    id: win

    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    visible: shutter.picking

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "screenshot"
    WlrLayershell.exclusiveZone: -1
    WlrLayershell.keyboardFocus: shutter.picking ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    // services/screenshot/Shutter.qml
    required property var shutter

    property bool dragging: false
    property real ox: 0     // drag origin
    property real oy: 0
    property real cx: 0     // current corner
    property real cy: 0

    readonly property real selX: Math.min(ox, cx)
    readonly property real selY: Math.min(oy, cy)
    readonly property real selW: Math.abs(cx - ox)
    readonly property real selH: Math.abs(cy - oy)

    function reset() {
        dragging = false;
        ox = 0; oy = 0; cx = 0; cy = 0;
    }

    // start clean every time the overlay is opened
    onVisibleChanged: if (visible) reset()

    // ------------------------------------------------------------------ keys
    Item {
        anchors.fill: parent
        focus: win.visible

        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Escape) {
                win.shutter.closePicker();
                event.accepted = true;
            }
        }
    }

    // ------------------------------------------------------------------ dim
    Rectangle {
        visible: win.dragging
        x: 0; y: 0
        width: win.width; height: win.selY
        color: "#000000"; opacity: 0.45
    }
    Rectangle {
        visible: win.dragging
        x: 0; y: win.selY + win.selH
        width: win.width
        height: Math.max(0, win.height - win.selY - win.selH)
        color: "#000000"; opacity: 0.45
    }
    Rectangle {
        visible: win.dragging
        x: 0; y: win.selY
        width: win.selX; height: win.selH
        color: "#000000"; opacity: 0.45
    }
    Rectangle {
        visible: win.dragging
        x: win.selX + win.selW; y: win.selY
        width: Math.max(0, win.width - win.selX - win.selW)
        height: win.selH
        color: "#000000"; opacity: 0.45
    }

    // ------------------------------------------------------------- size chip
    Rectangle {
        readonly property int chipW: sizeText.width + 18

        visible: win.dragging && win.selW > 48 && win.selH > 26
        x: win.selX
        y: Math.max(4, win.selY - 30)
        width: chipW
        height: 24
        radius: 6
        color: Theme.activeBg

        Text {
            id: sizeText
            anchors.centerIn: parent
            text: Math.round(win.selW) + " \u00d7 " + Math.round(win.selH)
            color: Theme.textPrimary
            font.family: Theme.textFont
            font.pixelSize: Theme.pixelSize
        }
    }

    // ----------------------------------------------------------- idle hint
    Rectangle {
        anchors.centerIn: parent
        visible: !win.dragging
        width: hintText.width + 36
        height: 36
        radius: 8
        color: Theme.bg
        opacity: 0.92

        Text {
            id: hintText
            anchors.centerIn: parent
            text: "Drag to select  \u00b7  Esc to cancel"
            color: Theme.textMuted
            font.family: Theme.textFont
            font.pixelSize: Theme.pixelSize
        }
    }

    // -------------------------------------------------------------- pointer
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.CrossCursor

        onPressed: function(mouse) {
            if (mouse.button !== Qt.LeftButton) {
                win.shutter.closePicker();
                return;
            }
            win.ox = mouse.x; win.oy = mouse.y;
            win.cx = mouse.x; win.cy = mouse.y;
            win.dragging = true;
        }

        onPositionChanged: function(mouse) {
            if (!win.dragging) return;
            win.cx = mouse.x;
            win.cy = mouse.y;
        }

        onReleased: function(mouse) {
            if (!win.dragging) return;
            win.cx = mouse.x;
            win.cy = mouse.y;

            const w = Math.abs(win.cx - win.ox);
            const h = Math.abs(win.cy - win.oy);
            const x = Math.min(win.ox, win.cx);
            const y = Math.min(win.oy, win.cy);

            win.reset();
            // Shutter closes the overlay itself
            win.shutter.captureRegion(x, y, w, h);
        }
    }
}
