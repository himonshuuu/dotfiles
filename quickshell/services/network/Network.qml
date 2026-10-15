import QtQuick
import Quickshell
import Quickshell.Io

// Link events + realtime throughput, read straight from procfs/sysfs.
Item {
    id: root
    visible: false

    property real rxRate: 0
    property real txRate: 0

    property bool armed: false
    property var known: ({})     // every non-lo interface seen
    property var links: ({})     // tracked NICs -> { cat, carrier }

    property real lastRx: -1
    property real lastTx: -1
    property real lastTime: 0

    // procfs/sysfs never fire inotify, so each tick forces reload() and the
    // blockAllReads flag makes text() wait for that fresh copy
    FileView { id: netDev; path: "/proc/net/dev"; blockAllReads: true; printErrors: false }
    FileView { id: sysfs; path: "/proc/net/dev"; blockAllReads: true; printErrors: false }

    Timer {
        interval: 200
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.sample()
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.trackLinks()
    }

    // don't announce the state the machine booted into
    Timer { interval: 4000; running: true; onTriggered: root.armed = true }

    function sysRead(rel) {
        sysfs.path = "/sys/class/net/" + rel
        sysfs.reload()
        return sysfs.text().trim()
    }

    function carrierOf(name) {
        const v = sysRead(name + "/carrier")
        return v === "1" ? 1 : (v === "0" ? 0 : -1)
    }

    function sample() {
        const now = Date.now() / 1000
        netDev.reload()
        const lines = netDev.text().split("\n")
        let rx = 0
        let tx = 0

        for (const line of lines) {
            const i = line.indexOf(":")
            if (i < 0) continue
            const name = line.slice(0, i).trim()
            const f = line.slice(i + 1).trim().split(/\s+/)
            if (name === "" || f.length < 9) continue
            if (name === "lo") continue
            rx += Number(f[0])
            tx += Number(f[8])
        }

        if (root.lastRx < 0) {
            root.lastRx = rx
            root.lastTx = tx
            root.lastTime = now
        } else {
            const dt = now - root.lastTime
            if (dt >= 0.1) {
                root.rxRate = Math.max(0, (rx - root.lastRx) / dt)
                root.txRate = Math.max(0, (tx - root.lastTx) / dt)
                root.lastRx = rx
                root.lastTx = tx
                root.lastTime = now
            }
        }
    }

    function trackLinks() {
        const names = []
        netDev.reload()
        for (const line of netDev.text().split("\n")) {
            const i = line.indexOf(":")
            if (i < 0) continue
            const name = line.slice(0, i).trim()
            if (name !== "") names.push(name)
        }
        const present = {}

        for (const name of names) {
            if (name === "lo" || name.startsWith("wl")) continue  // wifi never plugs
            present[name] = true
            if (root.known[name]) continue
            root.known[name] = true

            // no physical device behind it: docker, wg, veth...
            const uevent = sysRead(name + "/device/uevent")
            if (uevent === "") continue

            const cat = uevent.includes("usb_interface") ? "tether" : "eth"
            const c = carrierOf(name)
            root.links[name] = { cat: cat, carrier: c }
            if (c === 1) announce(name, cat, true)
        }

        for (const name of Object.keys(root.known)) {
            if (present[name]) continue
            delete root.known[name]
            const link = root.links[name]
            if (link === undefined) continue
            delete root.links[name]
            if (link.carrier === 1) announce(name, link.cat, false)
        }

        for (const name of Object.keys(root.links)) {
            const link = root.links[name]
            const c = carrierOf(name)
            if (c < 0 || c === link.carrier) continue
            link.carrier = c
            announce(name, link.cat, c === 1)
        }
    }

    function announce(name, cat, up) {
        if (!root.armed) return
        const tether = cat === "tether"
        notify(up ? (tether ? "USB tethering connected" : "Ethernet connected")
                  : (tether ? "USB tethering disconnected" : "Ethernet disconnected"),
               name + (up ? " link up" : " link down"),
               tether ? "phone" : "network-wired")
    }

    function notify(summary, body, icon) {
        Quickshell.execDetached(["notify-send", "-t", "6000", "-i", icon, summary, body])
    }
}
