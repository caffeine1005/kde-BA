import QtQuick

// Parallelogram leaning right, the signature Blue Archive button shape.
// The slanted plate stays inside this item's bounds.
Item {
    id: slant

    property real skew: height * 0.3
    property real radius: 0
    property color fillColor: "white"
    property color strokeColor: "transparent"
    property real strokeWidth: 1
    property Gradient gradient: null

    Rectangle {
        x: slant.skew / 2
        width: Math.max(0, slant.width - slant.skew)
        height: slant.height
        radius: slant.radius
        color: slant.fillColor
        gradient: slant.gradient
        border.color: slant.strokeColor
        border.width: slant.strokeWidth
        antialiasing: true
        transform: Matrix4x4 {
            matrix: Qt.matrix4x4(1, -slant.skew / Math.max(1, slant.height), 0, slant.skew / 2,
                                 0, 1, 0, 0,
                                 0, 0, 1, 0,
                                 0, 0, 0, 1)
        }
    }
}
