import QtQuick

// A tiny drawing of the Shittim Chest tablet (landscape, sky on the screen).
Item {
    id: glyph

    property color frameColor: "white"
    property color screenTop: "#BFEAFF"
    property color screenBottom: "#2CA0F0"

    implicitWidth: 32
    implicitHeight: 23

    Rectangle {
        anchors.fill: parent
        radius: height * 0.18
        color: glyph.frameColor
        antialiasing: true

        Rectangle {
            id: screen
            anchors.fill: parent
            anchors.topMargin: Math.max(1.5, parent.height * 0.12)
            anchors.bottomMargin: anchors.topMargin
            anchors.leftMargin: anchors.topMargin
            anchors.rightMargin: Math.max(3, parent.height * 0.26)
            radius: Math.max(1, parent.height * 0.08)
            gradient: Gradient {
                GradientStop { position: 0.0; color: glyph.screenTop }
                GradientStop { position: 1.0; color: glyph.screenBottom }
            }

            Rectangle {
                anchors.centerIn: parent
                width: Math.max(4, parent.height * 0.55)
                height: width
                radius: width / 2
                color: "transparent"
                border.color: "white"
                border.width: Math.max(1, width * 0.14)
                antialiasing: true
            }
        }

        Rectangle {
            anchors.right: parent.right
            anchors.rightMargin: Math.max(1, parent.height * 0.08)
            anchors.verticalCenter: parent.verticalCenter
            width: Math.max(2, parent.height * 0.1)
            height: width
            radius: width / 2
            color: glyph.screenBottom
        }
    }
}
