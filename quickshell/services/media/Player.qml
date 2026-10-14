import QtQuick
import Quickshell.Services.Mpris

// Picks the MPRIS player worth showing: the playing one first, then a paused
// one, then whatever is left.
Item {
    id: root

    property var player: null

    // hover card state - the card window maps off this
    property bool open: false

    function popupEnter() { closeTimer.stop(); root.open = true }
    function popupLeave() { closeTimer.start() }

    Timer { id: closeTimer; interval: 180; onTriggered: root.open = false }

    readonly property bool playing: player ? player.isPlaying : false
    readonly property string label: (player && player.trackTitle)
        ? player.trackTitle + (player.trackArtist ? " - " + player.trackArtist : "")
        : ""

    function pick() {
        const ps = Mpris.players.values || []
        if (ps.length === 0) { root.player = null; return }
        for (let i = 0; i < ps.length; i++)
            if (ps[i] && ps[i].isPlaying) { root.player = ps[i]; return }
        for (let j = 0; j < ps.length; j++)
            if (ps[j] && ps[j].playbackState === MprisPlaybackState.Paused) { root.player = ps[j]; return }
        root.player = ps[0]
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: root.pick()
    }
}
