import QtQuick
import Quickshell

// Installed applications + fuzzy search over DesktopEntries.applications. No visual code here.
Item {
    id: root

    // set by the launcher component (bound to the search field text)
    property string query: ""

    readonly property var entries: DesktopEntries.applications.values
    readonly property var results: root.search(root.query, root.entries)

    // match: >= 0 hit, -1 miss; substring > word boundary > subsequence, shorter names win ties.
    function match(needle, hay) {
        if (hay === "") return -1;

        var i = hay.indexOf(needle);
        if (i === 0) return 1000 - hay.length;
        if (i > 0) {
            var prev = hay.charAt(i - 1);
            var boundary = prev === " " || prev === "-" || prev === "." || prev === ":";
            return (boundary ? 800 : 620) - i * 2 - hay.length * 0.1;
        }

        // every character, in order - penalise how far in it starts and the
        // holes between the characters
        var hi = 0, gaps = 0, first = -1;
        for (var n = 0; n < needle.length; n++) {
            var j = hay.indexOf(needle.charAt(n), hi);
            if (j < 0) return -1;
            if (first < 0) first = j;
            gaps += j - hi;
            hi = j + 1;
        }
        return Math.max(1, 400 - first * 2 - gaps * 4);
    }

    // the name ranks above the generic name, which ranks above the keywords
    function score(needle, e) {
        var best = match(needle, String(e.name || "").toLowerCase());

        var g = match(needle, String(e.genericName || "").toLowerCase());
        if (g >= 0) best = Math.max(best, g - 120);

        var k = match(needle, String(e.keywords || "").toLowerCase());
        if (k >= 0) best = Math.max(best, k - 240);

        return best;
    }

    function search(q, list) {
        var all = list || [];
        var needle = String(q || "").trim().toLowerCase();

        // nothing typed yet: everything, A-Z
        if (needle === "") {
            var sorted = [];
            for (var k = 0; k < all.length; k++) {
                if (!all[k].noDisplay) sorted.push(all[k]);
            }
            sorted.sort(function(a, b) {
                return String(a.name).localeCompare(String(b.name));
            });
            return sorted;
        }

        var hits = [];
        for (var i = 0; i < all.length; i++) {
            var e = all[i];
            if (e.noDisplay) continue;
            var s = score(needle, e);
            if (s >= 0) hits.push({ e: e, s: s });
        }
        hits.sort(function(a, b) { return b.s - a.s; });
        return hits.map(function(h) { return h.e; });
    }

    // ------------------------------------------------------------ launching
    function launch(entry) {
        if (!entry) return;
        entry.execute();   // honours terminal / workingDirectory / actions
    }
}
