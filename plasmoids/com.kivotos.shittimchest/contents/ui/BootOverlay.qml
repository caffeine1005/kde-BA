import QtQuick
import org.kde.kirigami as Kirigami

// "Connecting to the Shittim Chest…" screen shown briefly when the launcher opens.
Rectangle {
    id: boot

    property real progress: 0

    function play() {
        sequence.restart();
    }

    function stop() {
        sequence.stop();
        opacity = 0;
    }

    radius: 10
    opacity: 0
    visible: opacity > 0
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#FFFFFF" }
        GradientStop { position: 1.0; color: "#E3F4FF" }
    }

    // Swallow clicks while booting
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
    }

    Column {
        anchors.centerIn: parent
        spacing: Kirigami.Units.largeSpacing

        Halo {
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.round(Kirigami.Units.gridUnit * 3.5)
            height: width
            color: root.baAccent
            spinning: boot.visible
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "SHITTIM CHEST"
            color: root.baNavy
            font.pixelSize: Math.round(Kirigami.Units.gridUnit * 1.6)
            font.weight: Font.Black
            font.italic: true
            font.letterSpacing: 2
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "シッテムの箱"
            color: root.baMuted
            font.pixelSize: Math.round(Kirigami.Units.gridUnit * 0.7)
            font.weight: Font.Bold
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.round(Kirigami.Units.gridUnit * 14)
            height: 6
            radius: 3
            color: "#D6ECFB"

            Rectangle {
                width: parent.width * boot.progress
                height: parent.height
                radius: 3
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "#7DD8FF" }
                    GradientStop { position: 1.0; color: root.baAccent }
                }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: boot.progress < 0.45 ? i18n("Connecting to the Shittim Chest…")
                : boot.progress < 0.95 ? i18n("Verifying Sensei's identity…")
                : i18n("Welcome back, Sensei!")
            color: root.baNavy
            font.pixelSize: Math.round(Kirigami.Units.gridUnit * 0.68)
            font.weight: Font.DemiBold
        }
    }

    SequentialAnimation {
        id: sequence
        PropertyAction { target: boot; property: "progress"; value: 0 }
        PropertyAction { target: boot; property: "opacity"; value: 1 }
        NumberAnimation { target: boot; property: "progress"; to: 1; duration: 700; easing.type: Easing.InOutCubic }
        PauseAnimation { duration: 150 }
        NumberAnimation { target: boot; property: "opacity"; to: 0; duration: 280; easing.type: Easing.OutQuad }
    }
}
