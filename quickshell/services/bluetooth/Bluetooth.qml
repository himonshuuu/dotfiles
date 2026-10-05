import QtQuick
import Quickshell
import Quickshell.Bluetooth

// Bluetooth control - replaces blueman-manager. All through Quickshell's BlueZ binding, no shell-out.
Item {
    id: root
    visible: false

    property bool open: false        // panel visibility - drives the component
    property var list: []            // devices, sorted for display
    property string fingerprint: ""

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool powered: !!adapter && adapter.enabled
    readonly property bool scanning: !!adapter && adapter.discovering
    readonly property string adapterName: adapter ? adapter.name : ""

    // ---------------------------------------------------------------- panel
    function togglePanel() { root.open ? root.closePanel() : root.openPanel() }

    function openPanel() {
        root.open = true;
        root.refresh();   // no point waiting a tick for the first list
    }

    function closePanel() { root.open = false }

    // -------------------------------------------------------------- adapter
    function setPowered(v) { if (adapter) adapter.enabled = v }
    function toggleScan() { if (adapter) adapter.discovering = !adapter.discovering }

    // -------------------------------------------------------------- devices
    // row click: connected -> disconnect, known -> connect, unknown -> pair
    function action(dev) {
        if (!dev) return;
        if (dev.connected) dev.disconnect();
        else if (dev.paired || dev.bonded) dev.connect();
        else dev.pair();
    }

    function forget(dev) { if (dev) dev.forget() }

    function rank(d) {
        if (d.connected) return 0;
        if (d.paired || d.bonded) return 1;
        return 2;
    }

    function refresh() {
        const model = Bluetooth.devices;
        const src = (model && model.values) ? Array.from(model.values) : [];
        const next = src.slice().sort(function(a, b) {
            const r = root.rank(a) - root.rank(b);
            if (r !== 0) return r;
            return String(a.deviceName || a.name || "")
                .localeCompare(String(b.deviceName || b.name || ""));
        });

        // only swap the array when something actually changed, so the panel's
        // delegates aren't torn down (and hover lost) every second
        var fp = "powered=" + root.powered + " scanning=" + root.scanning + "\n";
        for (var i = 0; i < next.length; i++) {
            const d = next[i];
            fp += d.address + "|" + d.connected + "|" + d.paired + "|" + d.bonded
                + "|" + d.pairing + "|" + d.state + "|" + d.battery
                + "|" + (d.deviceName || d.name) + "\n";
        }
        if (fp === root.fingerprint) return;

        root.fingerprint = fp;
        root.list = next;
    }

    // membership and order only matter while the panel is on screen
    Timer {
        interval: 1000
        running: root.open
        repeat: true
        onTriggered: root.refresh()
    }

    Connections {
        target: Bluetooth
        function onDefaultAdapterChanged() { root.refresh() }
    }

    Connections {
        target: root.adapter
        function onEnabledChanged() { root.refresh() }
        function onDiscoveringChanged() { root.refresh() }
    }
}
