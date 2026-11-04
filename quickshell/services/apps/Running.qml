import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

// Running windows in workspace order, paired with a desktop icon (cached in icon_cache.json).
Item {
    id: root

    property var list: []
    property var cache: ({})
    // addresses Hyprland has reported closed. quickshell can keep a closed
    // window's toplevel object around, which would render as a ghost tile.
    property var dead: ({})

    Process {
        id: cacheReader
        command: ["/bin/bash", "-c", "cat ~/.cache/quickshell/icon_cache.json 2>/dev/null || echo '{}'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.cache = JSON.parse(this.text ? this.text : "{}");
                } catch (e) {
                    root.cache = {};
                }
            }
        }
    }

    function iconFor(cls) {
        if (!cls) return "";
        const hit = root.cache[cls];
        if (hit !== undefined) return hit;

        const de = DesktopEntries.byId(cls) || DesktopEntries.heuristicLookup(cls);
        const name = (de && de.icon) ? de.icon : cls;

        const next = Object.assign({}, root.cache);
        next[cls] = name;
        root.cache = next;
        Quickshell.execDetached(["bash", "-c",
            "printf %s \"$1\" > ~/.cache/quickshell/icon_cache.json", "_", JSON.stringify(next)]);
        return name;
    }

    // Reuse the previous entry object when nothing about the window changed,
    // so the bar's delegates aren't torn down on every refresh.
    function entryFor(tl) {
        const cls = (tl.lastIpcObject && tl.lastIpcObject.class) ? tl.lastIpcObject.class
            : (tl.wayland && tl.wayland.appId) ? tl.wayland.appId : "";
        const activated = !!tl.activated;

        const prev = root.list;
        for (let i = 0; i < prev.length; i++) {
            const e = prev[i];
            if (e.tl === tl && e.cls === cls && e.activated === activated) return e;
        }
        return { tl: tl, cls: cls, activated: activated, icon: root.iconFor(cls) };
    }

    // Hyprland's own lifecycle events are authoritative - openwindow also
    // clears the mark, since addresses get reused between windows.
    function markClosed(addr) {
        if (!addr || root.dead[addr]) return;
        const next = Object.assign({}, root.dead);
        next[addr] = Date.now();
        root.dead = next;
    }

    function markOpened(addr) {
        if (!addr || !(addr in root.dead)) return;
        const next = Object.assign({}, root.dead);
        delete next[addr];
        root.dead = next;
    }

    function refresh() {
        Hyprland.refreshToplevels();

        const tls = Array.from(Hyprland.toplevels?.values ?? []);
        const live = {};
        for (const t of tls) live[String(t.address)] = true;
        const now = Date.now();

        // forget a mark once its window is gone for good, but keep it for a
        // while first: a ghost can show up slightly after the close event
        let drop = false;
        for (const k in root.dead)
            if (!live[k] && now - root.dead[k] > 10000) drop = true;
        if (drop) {
            const kept = {};
            for (const k in root.dead)
                if (live[k] || now - root.dead[k] <= 10000) kept[k] = root.dead[k];
            root.dead = kept;
        }

        const next = tls
            .filter(t => !(String(t.address) in root.dead))
            .sort((a, b) => (a.workspace?.id ?? 0) - (b.workspace?.id ?? 0))
            .map(t => root.entryFor(t));

        if (next.length === root.list.length) {
            let unchanged = true;
            for (let i = 0; i < next.length; i++)
                if (next[i] !== root.list[i]) { unchanged = false; break; }
            if (unchanged) return;
        }
        root.list = next;
    }

    Timer {
        interval: 1500
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Connections {
        target: Hyprland
        function onRawEvent(ev) {
            const data = String(ev.data ?? "");
            const addr = data.split(",")[0];
            if (ev.name === "closewindow") root.markClosed(addr);
            else if (ev.name === "openwindow") root.markOpened(addr);

            if (["openwindow", "closewindow", "movewindowv2", "workspacev2", "activewindowv2",
                 "changeworkspace", "renameworkspace", "windowtitle"].includes(ev.name))
                root.refresh();
        }
    }
}
