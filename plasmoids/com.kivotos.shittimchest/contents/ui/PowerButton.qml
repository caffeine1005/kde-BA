import QtQuick
import org.kde.kirigami as Kirigami

Item {
    id: button

    property string label
    property string iconName
    property bool primary: false

    signal clicked()

    implicitHeight: Math.round(Kirigami.Units.gridUnit * 1.9)
    implicitWidth: Math.round(content.implicitWidth + implicitHeight * 1.2)

    SlantedRect {
        anchors.fill: parent
        skew: height * 0.32
        fillColor: button.primary
            ? (mouse.containsMouse ? "#FFEC7A" : root.baYellow)
            : (mouse.containsMouse ? "white" : Qt.rgba(1, 1, 1, 0.85))
        strokeColor: button.primary ? "#E9C02E" : root.baLine
        scale: mouse.pressed ? 0.95 : 1
        Behavior on scale { NumberAnimation { duration: 100 } }
    }

    Row {
        id: content
        anchors.centerIn: parent
        spacing: Kirigami.Units.smallSpacing

        Kirigami.Icon {
            anchors.verticalCenter: parent.verticalCenter
            width: Kirigami.Units.iconSizes.small
            height: width
            source: button.iconName
            color: root.baNavy
            isMask: true
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: button.label
            color: root.baNavy
            font.pixelSize: Math.round(Kirigami.Units.gridUnit * 0.65)
            font.weight: Font.Bold
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: button.clicked()
    }
}
