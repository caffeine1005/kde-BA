import QtQuick

// A student halo: a ring with notches, optionally spinning.
Item {
    id: halo

    property color color: "#7FD6FF"
    property real thickness: Math.max(2, width * 0.06)
    property int ticks: 8
    property bool spinning: false

    implicitWidth: 64
    implicitHeight: 64

    Item {
        id: spinner
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            anchors.margins: halo.thickness * 1.6
            radius: width / 2
            color: "transparent"
            border.color: halo.color
            border.width: halo.thickness
            antialiasing: true
        }

        Repeater {
            model: halo.ticks

            Item {
                anchors.fill: parent
                rotation: index * 360 / halo.ticks

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: halo.thickness * (index % 2 === 0 ? 1.2 : 0.8)
                    height: halo.thickness * (index % 2 === 0 ? 2.8 : 2.0)
                    radius: width / 2
                    color: halo.color
                    antialiasing: true
                }
            }
        }

        RotationAnimator on rotation {
            running: halo.spinning && halo.visible
            from: 0
            to: 360
            duration: 9000
            loops: Animation.Infinite
        }
    }
}
