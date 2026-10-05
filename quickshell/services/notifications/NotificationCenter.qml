import QtQuick
import Quickshell
import Quickshell.Services.Notifications

// The notification daemon - Quickshell owns org.freedesktop.Notifications. Expiry: >0 = client ms, 0 = never, <0 = 5s (critical never).
Item {
    id: root
    visible: false

    readonly property int defaultTimeout: 5000  // mako's default-timeout
    readonly property int maxHistory: 50         // mako's max-history
    readonly property int maxPopups: 4           // mako's max-visible

    property var live: []     // Notification objects still on screen
    property var history: []  // snapshots of closed notifications, newest first
    property var popups: []   // Notification objects with a popup on screen
    property var items: []    // rows for the viewer, newest first
    property int activeCount: 0
    property string fingerprint: ""

    NotificationServer {
        id: server
        keepOnReload: true
        // live notifications survive a config reload with us; we just don't
        // promise to bring them back after a full quickshell restart
        persistenceSupported: true
        actionsSupported: true
        actionIconsSupported: true
        imageSupported: true
        bodyMarkupSupported: false   // bodies are rendered as plain text
        inlineReplySupported: false

        onNotification: function(n) {
            root.playSound();
            root.adopt(n);

            var arr = root.popups.concat([n]);
            while (arr.length > root.maxPopups) arr.shift();
            root.popups = arr;
        }
    }

    Component.onCompleted: {
        // keepOnReload hands surviving notifications back to us on a config
        // reload; they never go through onNotification a second time.
        try {
            var vals = server.trackedNotifications.values;
            for (var i = 0; i < vals.length; i++) root.adopt(vals[i]);
        } catch (e) {
            console.log("notifcenter: cannot read trackedNotifications: " + e);
        }
    }

    // ------------------------------------------------------------ lifetime

    function adopt(n) {
        if (live.indexOf(n) >= 0) return;
        n.tracked = true;
        live = live.concat([n]);
        n.closed.connect(function(reason) { onClosed(n, reason); });
        scheduleExpire(n);
        rebuild();
    }

    function onClosed(n, reason) {
        live = live.filter(function(x) { return x !== n; });
        popups = popups.filter(function(x) { return x !== n; });

        var h = snapshot(n, NotificationCloseReason.toString(reason));
        var arr = [h].concat(history);
        if (arr.length > maxHistory) arr.length = maxHistory;
        history = arr;

        rebuild();
    }

    function scheduleExpire(n) {
        var t = n.expireTimeout;
        if (t < 0)
            t = NotificationUrgency.toString(n.urgency) === "Critical"
                ? 0 : defaultTimeout;
        if (t <= 0) return;   // 0 == never expire
        later(t, function() {
            if (live.indexOf(n) >= 0) n.expire();
        });
    }

    // one-shot timer for an expiry we have to schedule ourselves
    function later(ms, fn) {
        var t = Qt.createQmlObject("import QtQuick; Timer { repeat: false }", root);
        t.triggered.connect(function() { t.destroy(); fn(); });
        t.interval = Math.max(1, ms);
        t.start();
    }

    // --------------------------------------------------------------- rows

    function actionsOf(n) {
        var out = [];
        for (var i = 0; i < n.actions.length; i++)
            out.push({ index: i, label: n.actions[i].text });
        return out;
    }

    function snapshot(n, reason) {
        return {
            id: n.id,
            app: n.appName || "",
            icon: n.appIcon || "",
            image: n.image || "",
            summary: n.summary || "",
            body: n.body || "",
            urgency: NotificationUrgency.toString(n.urgency),
            expireTimeout: n.expireTimeout,
            actionList: actionsOf(n),
            reason: reason || "",
            active: false,
            ref: null
        };
    }

    function rebuild() {
        var rows = [], i, h;

        for (i = 0; i < live.length; i++) {
            h = snapshot(live[i], "");
            h.active = true;
            h.ref = live[i];
            rows.push(h);
        }
        for (i = 0; i < history.length; i++) rows.push(history[i]);
        rows.sort(function(a, b) { return (b.id || 0) - (a.id || 0); });

        activeCount = live.length;

        // Only swap the model when the content really changed, otherwise the
        // ListView would be reset (and lose its scroll position) for nothing.
        var fp = "";
        for (i = 0; i < rows.length; i++) {
            var r = rows[i];
            fp += r.id + "|" + r.active + "|" + r.app + "|" + r.summary + "|"
                + r.body + "|" + r.urgency + "|" + r.actionList.length + "\n";
        }
        if (fp === fingerprint) return;
        fingerprint = fp;
        items = rows;
    }

    // ------------------------------------------------------------- public

    function dismiss(row) {
        if (row && row.ref) row.ref.dismiss();
    }

    function invoke(row, index) {
        if (!row || !row.ref) return;
        var a = row.ref.actions[index];
        if (a) a.invoke();
    }

    function dismissAll() {
        var copy = live.slice();
        for (var i = 0; i < copy.length; i++) copy[i].dismiss();
    }

    function clearHistory() {
        history = [];
        rebuild();
    }

    // preview.wav sits next to this file; paplay only takes real paths
    function playSound() {
        var u = String(Qt.resolvedUrl("preview.wav"));
        if (u.indexOf("file://") === 0) u = u.slice(7);
        Quickshell.execDetached(["paplay", u]);
    }
}
