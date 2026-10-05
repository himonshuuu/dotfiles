import QtQuick
import Quickshell.Io

// Backlight brightness read from sysfs. sysfs has no inotify, so the file is
// polled. `changed` only fires on a real move - never for the first read.
Item {
    id: root

    property int percentage: -1

    signal changed(int pct)

    FileView {
        id: cur
        path: "/sys/class/backlight/amdgpu_bl1/brightness"
        preload: true
        printErrors: false
        onTextChanged: root.tick()
    }
    FileView {
        id: max
        path: "/sys/class/backlight/amdgpu_bl1/max_brightness"
        preload: true
        printErrors: false
        onTextChanged: root.tick()
    }

    function tick() {
        const b = parseInt(cur.text());
        const m = parseInt(max.text());
        if (!isFinite(b) || !isFinite(m) || m <= 0) return;

        const pct = Math.round(Math.max(0, Math.min(1, b / m)) * 100);
        if (pct === root.percentage) return;

        const first = root.percentage < 0;      // initial read, don't announce it
        root.percentage = pct;
        if (!first) root.changed(pct);
    }

    Timer {
        interval: 400
        running: true
        repeat: true
        onTriggered: cur.reload()
    }
}
