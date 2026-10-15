import QtQuick
import Quickshell.Io
import Quickshell.Services.Pipewire

// IPC surface: qs ipc call activity <info>
Item {
    id: ipc
    visible: false

    // services/activity/Activity.qml
    property var activity

    IpcHandler {
        target: "activity"

        function togglePrivate(): void { ipc.activity.togglePrivate() }

        function info(): string {
            const nodes = ipc.activity.allNodes
            var video = []
            for (var i = 0; i < nodes.length; i++)
                if (nodes[i].type === (PwNodeType.Video | PwNodeType.Source))
                    video.push(nodes[i].name)
            return JSON.stringify({
                micOpen: ipc.activity.micOpen,
                micMuted: ipc.activity.micMuted,
                speaking: ipc.activity.speaking,
                micPeak: Number(ipc.activity.micPeak.toFixed(3)),
                soundOpen: ipc.activity.speakerOpen,
                speakerMuted: ipc.activity.speakerMuted,
                sounding: ipc.activity.sounding,
                soundPeak: Number(ipc.activity.soundPeak.toFixed(3)),
                capturing: ipc.activity.capturing,
                privateScreen: ipc.activity.privateScreen,
                video: video
            })
        }
    }
}
