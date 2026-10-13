import QtQuick
import org.kde.kirigami as Kirigami

// Top-bar resource counter: icon overlapping a dark translucent pill, with a "+" button.
Item {
    id: pill

    property string kind: "ap"
    property string text: ""

    signal bodyPressed()
    signal bodyClicked()
    signal plusClicked()

    readonly property real iconSize: height
    readonly property real bodyHeight: Math.round(height * 0.72)
    readonly property real plusSize: Math.round(bodyHeight * 0.74)
    readonly property real textWidth: Math.max(label.implicitWidth, height * 1.7)

    implicitHeight: Math.round(Kirigami.Units.gridUnit * 1.6)
    implicitWidth: iconSize * 0.5 + body.width

    MouseArea {
        id: bodyMouse
        anchors.fill: parent
        hoverEnabled: true
        onPressed: pill.bodyPressed()
        onClicked: pill.bodyClicked()
    }

    Rectangle {
        id: body
        x: pill.iconSize * 0.5
        anchors.verticalCenter: parent.verticalCenter
        height: pill.bodyHeight
        width: pill.iconSize * 0.5 + Kirigami.Units.smallSpacing * 4 + pill.textWidth + pill.plusSize + (pill.bodyHeight - pill.plusSize) / 2
        radius: height / 2
        color: bodyMouse.containsMouse ? Qt.rgba(0.16, 0.28, 0.45, 0.88) : Qt.rgba(0.13, 0.22, 0.36, 0.74)
        border.color: Qt.rgba(1, 1, 1, 0.35)
        border.width: 1

        Text {
            id: label
            x: pill.iconSize * 0.5 + Kirigami.Units.smallSpacing * 2
            width: pill.textWidth
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Text.AlignHCenter
            text: pill.text
            color: "white"
            font.pixelSize: Math.round(pill.bodyHeight * 0.52)
            font.weight: Font.Bold
            font.italic: true
        }

        Rectangle {
            id: plus
            anchors.right: parent.right
            anchors.rightMargin: (pill.bodyHeight - pill.plusSize) / 2
            anchors.verticalCenter: parent.verticalCenter
            width: pill.plusSize
            height: width
            radius: width / 2
            color: plusMouse.containsMouse ? "#5BC0FF" : "#2CA0F0"

            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 0.55
                height: Math.max(2, Math.round(parent.width * 0.14))
                radius: height / 2
                color: "white"
            }

            Rectangle {
                anchors.centerIn: parent
                width: Math.max(2, Math.round(parent.width * 0.14))
                height: parent.width * 0.55
                radius: width / 2
                color: "white"
            }

            MouseArea {
                id: plusMouse
                anchors.fill: parent
                anchors.margins: -2
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onPressed: pill.bodyPressed()
                onClicked: pill.plusClicked()
            }
        }
    }

    Loader {
        width: pill.iconSize
        height: pill.iconSize
        anchors.verticalCenter: parent.verticalCenter
        sourceComponent: pill.kind === "credit" ? creditIcon
            : pill.kind === "pyroxene" ? pyroxeneIcon
            : apIcon
    }

    Component {
        id: apIcon

        Rectangle {
            radius: width / 2
            border.color: "white"
            border.width: Math.max(1.5, width * 0.07)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#7DD8FF" }
                GradientStop { position: 1.0; color: "#1E7FE0" }
            }

            Text {
                anchors.centerIn: parent
                text: "AP"
                color: "white"
                font.pixelSize: Math.round(parent.height * 0.36)
                font.weight: Font.Black
                font.italic: true
            }
        }
    }

    Component {
        id: creditIcon

        Rectangle {
            radius: width / 2
            border.color: "#FFF6CF"
            border.width: Math.max(1.5, width * 0.07)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#FFE98A" }
                GradientStop { position: 1.0; color: "#F2A92E" }
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: parent.width * 0.22
                radius: width / 2
                color: "transparent"
                border.color: "#D98E1A"
                border.width: Math.max(1, parent.width * 0.07)
            }

            Rectangle {
                x: parent.width * 0.26
                y: parent.height * 0.2
                width: parent.width * 0.16
                height: width
                radius: width / 2
                color: "white"
                opacity: 0.85
            }
        }
    }

    Component {
        id: pyroxeneIcon

        Item {
            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 0.6
                height: width
                rotation: 45
                radius: width * 0.08
                antialiasing: true
                border.color: "white"
                border.width: Math.max(1.2, parent.width * 0.06)
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#D4F6FF" }
                    GradientStop { position: 0.5; color: "#55B8FF" }
                    GradientStop { position: 1.0; color: "#3A6BFF" }
                }
            }

            Rectangle {
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -parent.height * 0.08
                width: parent.width * 0.12
                height: parent.height * 0.26
                radius: width / 2
                color: "white"
                opacity: 0.75
            }
        }
    }
}
