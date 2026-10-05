import QtQuick
import Quickshell
import Quickshell.Io

// Which image is on screen; the pick is cached so a reload doesn't reshuffle the desktop.
Item {
    id: root

    readonly property string dir: String(Quickshell.env("HOME")) + "/Pictures/Wallpapers"
    readonly property string store: String(Quickshell.env("HOME")) + "/.cache/quickshell/wallpaper"

    // this Qt only ships png/jpeg/gif decoders - no webp plugin - so anything
    // else would be picked, persisted and then fail to render as a flat card
    readonly property var supported: /\.(png|jpe?g|gif)$/i

    property string current: ""   // rendered on top by Backdrop
    property string previous: ""  // the layer being cross-faded away
    property var files: []
    property bool pickPending: false

    // ------------------------------------------------------------ selection
    Process {
        id: lister
        command: ["find", root.dir, "-maxdepth", "1", "-type", "f"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const raw = this.text ? this.text.split("\n") : [];
                root.files = raw
                    .filter(f => f !== "" && root.supported.test(f))
                    .sort();

                // pick only when asked to, or when nothing has been shown yet
                if (root.pickPending || root.current === "") {
                    root.pickPending = false;
                    root.pickRandom();
                }
            }
        }
        stderr: StdioCollector {}
    }

    // ----------------------------------------------------------- last pick
    FileView {
        id: pick
        path: root.store
        preload: true
        printErrors: false

        onLoaded: {
            // ignore a stored path this build of Qt can no longer decode
            const p = this.text();
            if (p && root.supported.test(p)) root.apply(p);
        }
    }

    // IPC + keybind entry point: re-list the folder and take a new image
    function random() {
        root.pickPending = true;
        if (!lister.running) lister.running = true;
    }

    function pickRandom() {
        if (root.files.length === 0) return;
        root.apply(root.files[Math.floor(Math.random() * root.files.length)]);
    }

    function apply(path) {
        if (!path || path === root.current) return;
        root.previous = root.current;  // Backdrop fades from this one
        root.current = path;
        // setText() writes the file itself - FileView has no save()
        pick.setText(path);
    }
}
