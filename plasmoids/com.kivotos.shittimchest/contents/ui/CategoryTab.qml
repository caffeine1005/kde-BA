import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Item {
    id: tab

    property string label
    property var iconSource
    property bool selected: false

    signal clicked()

    height: Math.round(Kirigami.Units.gridUnit * 2)

    SlantedRect {
        anchors.fill: parent
        anchors.rightMargin: tab.selected ? 0 : Kirigami.Units.smallSpacing * 2
        skew: height * 0.3
        fillColor: tab.selected ? root.baAccent : (mouse.containsMouse ? "white" : Qt.rgba(1, 1, 1, 0.72))
        strokeColor: tab.selected ? "white" : root.baLine
        Behavior on anchors.rightMargin { NumberAnimation { duration: 120 } }
    }

    // Yellow marker on the selected tab
    Rectangle {
        visible: tab.selected
        x: tab.height * 0.42
        anchors.verticalCenter: parent.verticalCenter
        width: 3
        height: tab.height * 0.45
        radius: 1.5
        color: root.baYellow
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Math.round(tab.height * 0.62)
        anchors.rightMargin: Math.round(tab.height * 0.5)
        spacing: Kirigami.Units.smallSpacing

        Kirigami.Icon {
            Layout.preferredWidth: Kirigami.Units.iconSizes.small
            Layout.preferredHeight: Kirigami.Units.iconSizes.small
            source: tab.iconSource
        }

        Text {
            Layout.fillWidth: true
            text: tab.label
            color: tab.selected ? "white" : root.baNavy
            elide: Text.ElideRight
            font.pixelSize: Math.round(Kirigami.Units.gridUnit * 0.66)
            font.weight: tab.selected ? Font.Black : Font.DemiBold
            font.italic: tab.selected
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: tab.clicked()
    }
}
