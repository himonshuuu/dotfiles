import QtQuick
import Quickshell.Services.Pipewire

// Current output volume and mute from PipeWire; `changed` never fires on the first sync.
Item {
    id: root

    property real level: 0     // 0..1, may go above 1 with boosted volumes
    property bool muted: false
    property int _pct: -1      // last rounded percentage, used to detect moves

    signal changed(real level, bool muted)

    readonly property var sink: Pipewire.defaultAudioSink ? Pipewire.defaultAudioSink.audio : null

    // seed the current level as soon as the node shows up, so the first real
    // change announces itself instead of being swallowed as the initial sync
    onSinkChanged: root.sync()
    Component.onCompleted: root.sync()

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink].filter(n => n !== null && n !== undefined)
    }

    function sync() {
        const a = root.sink;
        if (!a) return;

        const pct = Math.round(Math.min(a.volume, 1) * 100);
        if (root._pct < 0) {                    // initial sync, don't announce it
            root._pct = pct;
            root.level = a.volume;
            root.muted = a.muted;
            return;
        }
        if (pct === root._pct && a.muted === root.muted) return;

        root._pct = pct;
        root.level = a.volume;
        root.muted = a.muted;
        root.changed(root.level, root.muted);
    }

    Connections {
        target: root.sink
        function onVolumesChanged() { root.sync() }
        function onMutedChanged() { root.sync() }
    }
}
