import QtQuick
import "../../config/theme.js" as Theme

// Realtime throughput island.
Rectangle {
    id: pill

    implicitHeight: 30
    implicitWidth: row.implicitWidth + 20
    radius: Theme.radiusOuter
    color: Theme.bg

    required property var net

    // clamped so "999.9M" (valueRef) is the widest string ever shown
    function rate(bps) {
        if (bps < 1024) return Math.round(bps) + "B"
        if (bps < 1048576) return Math.min(bps / 1024, 999.9).toFixed(1) + "K"
        if (bps < 1073741824) return Math.min(bps / 1048576, 999.9).toFixed(1) + "M"
        return Math.min(bps / 1073741824, 999.9).toFixed(1) + "G"
    }

    Text {
        id: valueRef
        visible: false
        text: "999.9M"
        font.family: Theme.textFont
        font.pixelSize: Theme.pixelSize
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 4

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: ""
            color: pill.net.rxRate > 0 ? Theme.hot : Theme.textMuted
            font.family: Theme.textFont
            font.pixelSize: Theme.pixelSize
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            width: valueRef.implicitWidth
            text: pill.rate(pill.net.rxRate)
            color: Theme.textPrimary
            font.family: Theme.textFont
            font.pixelSize: Theme.pixelSize
        }

        Item { width: 9; height: 1 }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: ""
            color: pill.net.txRate > 0 ? Theme.hot : Theme.textMuted
            font.family: Theme.textFont
            font.pixelSize: Theme.pixelSize
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            width: valueRef.implicitWidth
            text: pill.rate(pill.net.txRate)
            color: Theme.textPrimary
            font.family: Theme.textFont
            font.pixelSize: Theme.pixelSize
        }
    }
}
