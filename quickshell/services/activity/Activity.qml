import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.Pipewire

// Mic / speaker / screen-share activity, read from the pipewire graph.
Item {
    id: root
    visible: false

    // tunable: mic peak counted as speech, sink peak counted as audible
    // (speakers bleeding into the mic sit around 0.1, real speech well above)
    property real speakAt: 0.15
    property real soundAt: 0.02

    readonly property var allNodes: Pipewire.nodes.values

    readonly property bool micOpen: hasType(allNodes, PwNodeType.AudioInStream)
    readonly property bool speakerOpen: hasType(allNodes, PwNodeType.AudioOutStream)
    readonly property bool capturing: hasCapture(allNodes)

    readonly property real micPeak: micMonitor.peak
    readonly property real soundPeak: sinkMonitor.peak

    readonly property bool speaking: micPeak >= speakAt
    readonly property bool sounding: soundPeak >= soundAt

    readonly property var micAudio: Pipewire.defaultAudioSource && Pipewire.defaultAudioSource.audio
    readonly property var sinkAudio: Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio
    readonly property bool micMuted: micAudio ? micAudio.muted : false
    readonly property bool speakerMuted: sinkAudio ? sinkAudio.muted : false

    // private: every window tagged "private" — windowrules.lua hides those from
    // screen sharing, same mechanism as the SUPER+G bind
    property bool privateScreen: false

    function toggleMic() {
        if (micAudio) micAudio.muted = !micAudio.muted
    }

    function toggleSpeaker() {
        if (sinkAudio) sinkAudio.muted = !sinkAudio.muted
    }

    function togglePrivate() {
        privateScreen = !privateScreen
        Quickshell.execDetached(["hyprctl", "eval", luaTagAll(privateScreen)])
    }

    // the tag dispatcher toggles, so only touch windows whose state differs
    function luaTagAll(want) {
        return "for _, w in ipairs(hl.get_windows()) do local has = false; "
            + "for _, t in ipairs(w.tags or {}) do if t == 'private' then has = true end end; "
            + "if has ~= " + want + " then hl.dispatch(hl.dsp.window.tag({ tag = 'private', window = w })) end end"
    }

    // windows opened while private is on join the tag
    Connections {
        target: Hyprland
        function onRawEvent(ev) {
            if (root.privateScreen && ev.name === "openwindow")
                Quickshell.execDetached(["hyprctl", "eval", root.luaTagAll(true)])
        }
    }

    // tags live in the session — pick the real state up once at startup
    Process {
        running: true
        command: ["hyprctl", "repl", "local ws = hl.get_windows(); local all = #ws > 0; for _, w in ipairs(ws) do local has = false; for _, t in ipairs(w.tags or {}) do if t == 'private' then has = true end end; if not has then all = false end end; return all"]
        stdout: StdioCollector {
            onStreamFinished: root.privateScreen = this.text.trim() === "true"
        }
    }

    function hasType(nodes, type) {
        for (var i = 0; i < nodes.length; i++)
            if (nodes[i].type === type) return true
        return false
    }

    // v4l2_* nodes are physical webcams; any other video source is an app capturing
    function hasCapture(nodes) {
        for (var i = 0; i < nodes.length; i++)
            if (nodes[i].type === (PwNodeType.Video | PwNodeType.Source)
                    && nodes[i].name.indexOf("v4l2_") !== 0) return true
        return false
    }

    PwNodePeakMonitor { id: micMonitor; node: Pipewire.defaultAudioSource }
    PwNodePeakMonitor { id: sinkMonitor; node: Pipewire.defaultAudioSink }
}
