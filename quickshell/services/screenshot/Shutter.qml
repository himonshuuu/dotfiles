import QtQuick
import Quickshell
import Quickshell.Io

// Region screenshot: pick, capture, copy, announce. wl-copy reads stdin, hence the one `<`.
Item {
    id: root
    visible: false

    readonly property string dir: String(Quickshell.env("HOME")) + "/Pictures/Screenshots"

    property bool picking: false   // RegionPicker binds its visibility to this
    property string path: ""
    property string geom: ""       // "x,y WxH" - empty means the whole desktop

    // -------------------------------------------------------------- actions

    function openPicker() {
        root.geom = "";
        root.picking = true;
    }

    function closePicker() { root.picking = false }

    function captureFull() {
        root.picking = false;
        root.start("");
    }

    function captureRegion(x, y, w, h) {
        root.picking = false;
        if (w < 4 || h < 4) return;   // a click, not a selection
        root.start(Math.round(x) + "," + Math.round(y) + " "
            + Math.round(w) + "x" + Math.round(h));
    }

    // -------------------------------------------------------------- pipeline

    function start(geometry) {
        root.geom = geometry;
        root.path = root.dir + "/"
            + Qt.formatDateTime(new Date(), "yyyy-MM-dd_HH-mm-ss")
            + (geometry ? "_area" : "") + ".png";
        prep.running = true;
    }

    // 1. make sure the folder exists, 2. hand grim a geometry, 3. share it
    Process {
        id: prep
        command: ["mkdir", "-p", root.dir]

        onExited: function() {
            shot.command = root.geom
                ? ["grim", "-g", root.geom, root.path]
                : ["grim", root.path];
            shot.running = true;
        }
    }

    Process {
        id: shot

        onExited: function(exitCode, exitStatus) {
            if (exitCode === 0) {
                root.share();
            } else {
                // grim leaves a stub behind when it fails
                Quickshell.execDetached(["rm", "-f", root.path]);
                console.log("screenshot: grim failed with code " + exitCode);
            }
        }
    }

    function share() {
        Quickshell.execDetached(["sh", "-c",
            "wl-copy --type image/png < \"$1\"", "qs-shutter", root.path]);

        Quickshell.execDetached(["notify-send", "-i", root.path, "Screenshot",
            "Saved " + root.baseName() + " \u2014 copied to clipboard"]);
    }

    function baseName() {
        const i = root.path.lastIndexOf("/");
        return i < 0 ? root.path : root.path.slice(i + 1);
    }
}
