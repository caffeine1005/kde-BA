import QtQuick

// Login splash: the Shittim Chest booting up.
Rectangle {
    id: root

    property int stage: 0

    readonly property real unit: Math.max(8, height / 54)
    readonly property var messages: [
        "Booting A.R.O.N.A. system…",
        "Booting A.R.O.N.A. system…",
        "Connecting to the Kivotos network…",
        "Synchronizing with S.C.H.A.L.E…",
        "Authenticating Sensei…",
        "Welcome back, Sensei!"
    ]

    gradient: Gradient {
        GradientStop { position: 0.0; color: "#3FA9F5" }
        GradientStop { position: 0.55; color: "#A6DBFB" }
        GradientStop { position: 1.0; color: "#F2FAFF" }
    }

    // Light beams
    Repeater {
        model: [0.58, 0.7, 0.78]

        Rectangle {
            x: root.width * modelData
            y: -root.height * 0.1
            width: root.width * (index === 1 ? 0.03 : 0.07)
            height: root.height * 1.3
            rotation: 26
            transformOrigin: Item.Top
            opacity: 0.16
            gradient: Gradient {
                GradientStop { position: 0.0; color: "white" }
                GradientStop { position: 0.8; color: Qt.rgba(1, 1, 1, 0) }
            }
        }
    }

    // Cloud bank
    Repeater {
        model: 10

        Rectangle {
            readonly property real size: root.width * (0.16 + 0.05 * (index % 3))
            width: size
            height: size * 0.5
            radius: height / 2
            x: root.width * (index / 9) - size / 2
            y: root.height - height * (0.55 + 0.18 * (index % 2))
            color: "white"
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height * 0.06
        color: "white"
    }

    Text {
        x: root.unit * 2
        y: root.unit * 1.5
        text: "A.R.O.N.A. SYSTEM  v1.0"
        color: "white"
        opacity: 0.85
        font.pixelSize: Math.round(root.unit * 0.9)
        font.weight: Font.Bold
        font.letterSpacing: 2
    }

    Column {
        id: content
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -root.height * 0.06
        spacing: root.unit * 1.2
        opacity: 0

        NumberAnimation on opacity {
            to: 1
            duration: 700
            easing.type: Easing.OutQuad
        }

        Item {
            id: halo
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.round(root.unit * 9)
            height: width

            readonly property real thickness: width * 0.05

            Rectangle {
                anchors.fill: parent
                anchors.margins: halo.thickness * 1.6
                radius: width / 2
                color: "transparent"
                border.color: "white"
                border.width: halo.thickness
                antialiasing: true
            }

            Repeater {
                model: 12

                Item {
                    anchors.fill: parent
                    rotation: index * 30

                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: halo.thickness * (index % 3 === 0 ? 1.3 : 0.8)
                        height: halo.thickness * (index % 3 === 0 ? 3 : 2)
                        radius: width / 2
                        color: "white"
                        antialiasing: true
                    }
                }
            }

            RotationAnimator on rotation {
                from: 0
                to: 360
                duration: 8000
                loops: Animation.Infinite
                running: true
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "SHITTIM CHEST"
            color: "white"
            font.pixelSize: Math.round(root.unit * 3.4)
            font.weight: Font.Black
            font.italic: true
            font.letterSpacing: root.unit * 0.3
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "シッテムの箱"
            color: "white"
            opacity: 0.9
            font.pixelSize: Math.round(root.unit * 1.2)
            font.weight: Font.Bold
        }

        Rectangle {
            id: track
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.round(root.unit * 26)
            height: Math.max(4, Math.round(root.unit * 0.45))
            radius: height / 2
            color: Qt.rgba(1, 1, 1, 0.35)

            Rectangle {
                width: track.width * Math.min(1, Math.max(0.05, root.stage / 6))
                height: parent.height
                radius: height / 2
                color: "white"
                Behavior on width { NumberAnimation { duration: 450; easing.type: Easing.OutCubic } }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.messages[Math.max(0, Math.min(root.stage, root.messages.length - 1))]
            color: "white"
            font.pixelSize: Math.round(root.unit * 1.0)
            font.weight: Font.DemiBold
        }
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: root.unit * 2
        text: "“We desire the Seven Lamentations. We remember the ancient laws of Jericho.”"
        color: "#4A6A90"
        font.pixelSize: Math.round(root.unit * 0.85)
        font.italic: true
    }
}
