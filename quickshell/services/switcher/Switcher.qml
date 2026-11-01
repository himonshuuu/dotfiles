import QtQuick
import Quickshell
import Quickshell.Hyprland

// MRU window switcher (SUPER+Tab). open() lays out the ring in most-recently
// used order, next/prev only move the selection - focus moves on confirm().
Item {
    id: root
    visible: false

    // services/apps/Running - iconFor()
    required property var apps

    property bool isOpen: false
    property int index: 0
    property var cycle: []       // [{ tl, addr, cls, title, icon }]
    property var mru: []         // window addresses, most recent first

    function open() {
        const rank = {}
        root.mru.forEach((a, i) => rank[a.replace(/^0x/, "")] = i)

        const ring = Array.from(Hyprland.toplevels?.values ?? [])
            .filter(t => t.lastIpcObject && t.lastIpcObject.address)
            .map(t => ({
                tl: t,
                addr: t.lastIpcObject.address,
                cls: t.lastIpcObject.class || "",
                title: t.lastIpcObject.title || "",
                icon: root.apps.iconFor(t.lastIpcObject.class)
            }))
            .sort((a, b) => (rank[a.addr.replace(/^0x/, "")] ?? 1e9) - (rank[b.addr.replace(/^0x/, "")] ?? 1e9))

        if (ring.length === 0) return

        // the focused window belongs in the ring, but never as the first pick
        const fi = ring.findIndex(e => e.tl.activated)
        if (fi > 0) ring.unshift(ring.splice(fi, 1)[0])

        root.cycle = ring
        root.index = ring.length > 1 ? 1 : 0
        root.isOpen = true
    }

    function close() { root.isOpen = false }

    function next() {
        if (!root.isOpen) { root.open(); return }
        root.move(1)
    }

    function prev() {
        if (!root.isOpen) { root.open(); if (root.cycle.length > 1) root.index = root.cycle.length - 1; return }
        root.move(-1)
    }

    function move(delta) {
        const n = root.cycle.length
        if (!root.isOpen || n === 0) return
        root.index = (root.index + delta + n) % n
    }

    function confirm() {
        if (!root.isOpen) return
        const picked = root.cycle[root.index]
        root.isOpen = false
        if (!picked || !picked.addr) return
        // the popup's exclusive keyboard grab releases on unmap; commit focus after that
        focusCommit.addr = picked.addr
        focusCommit.restart()
    }

    Timer {
        id: focusCommit
        property string addr: ""
        interval: 100
        onTriggered: {
            if (addr === "") return
            Hyprland.dispatch(`(function() for _, w in ipairs(hl.get_windows()) do if w.address == "${addr}" then return hl.dsp.focus({ window = w }) end end return hl.dsp.exec_cmd("true") end)()`)
            addr = ""
        }
    }

    function info() {
        return JSON.stringify({
            open: root.isOpen,
            index: root.index,
            mru: root.mru,
            cycle: root.cycle.map(e => ({ addr: e.addr, cls: e.cls, title: e.title }))
        })
    }

    Connections {
        target: Hyprland
        function onRawEvent(ev) {
            if (ev.name === "activewindowv2" || ev.name === "openwindow") {
                const addr = ev.data.split(",")[0]
                if (!addr) return
                const bare = addr.replace(/^0x/, "")
                root.mru = [bare].concat(root.mru.filter(a => a.replace(/^0x/, "") !== bare)).slice(0, 32)
            } else if (ev.name === "closewindow") {
                const addr = ev.data.split(",")[0]
                if (!addr) return
                const bare = addr.replace(/^0x/, "")
                root.mru = root.mru.filter(a => a.replace(/^0x/, "") !== bare)
                if (!root.isOpen) return
                const gone = root.cycle.findIndex(e => e.addr.replace(/^0x/, "") === bare)
                if (gone === -1) return
                const ring = root.cycle.slice()
                ring.splice(gone, 1)
                if (ring.length === 0) { root.isOpen = false; return }
                root.cycle = ring
                if (gone < root.index) root.index--
                root.index = root.index % ring.length
            }
        }
    }
}
