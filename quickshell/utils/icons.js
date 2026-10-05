.pragma library

// Icon/image source resolution, shared by the popup stack and history panel.

// a plain path -> a url QtQuick.Image accepts
function source(s) {
    s = String(s || "");
    if (!s) return "";
    return s.charAt(0) === "/" ? "file://" + s : s;
}

// the real picture to show big, or "" when `image` only holds an icon
function picture(image) {
    var s = String(image || "");
    if (!s || s.indexOf("image://icon/") === 0) return "";
    return source(s);
}

// Best source: image -> icon -> themed "notifications" (Quickshell.iconPath, passed in from QML).
function resolve(image, icon, themed) {
    var s = source(image);
    if (s) return s;

    s = String(icon || "");
    if (s) {
        if (s.charAt(0) === "/") return "file://" + s;
        if (s.indexOf("file:") === 0) return s;
        var p = themed(s);
        if (p) return String(p);
    }

    var d = themed("notifications");
    return d ? String(d) : "";
}
