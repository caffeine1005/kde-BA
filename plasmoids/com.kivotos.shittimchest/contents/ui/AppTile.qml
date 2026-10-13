import QtQuick
import org.kde.kirigami as Kirigami

// An app card in the style of a Blue Archive item/student card.
Item {
    id: tile

    property string label
    property var iconSource
    property string subtitle

    readonly property bool isCurrent: GridView.isCurrentItem
    readonly property bool hot: mouse.containsMouse || isCurrent
    readonly property real cornerSize: Math.round(Kirigami.Units.gridUnit * 0.9)

    signal activated()
    signal hovered()

    width: GridView.view ? GridView.view.cellWidth : 0
    height: GridView.view ? GridView.view.cellHeight : 0

    Rectangle {
        id: card
        anchors.fill: parent
        anchors.margins: Kirigami.Units.smallSpacing
        radius: 6
        color: tile.hot ? "white" : Qt.rgba(1, 1, 1, 0.8)
        border.width: tile.isCurrent ? 2 : 1
        border.color: tile.hot ? root.baAccent : root.baLine
        scale: mouse.pressed ? 0.95 : (mouse.containsMouse ? 1.04 : 1.0)
        Behavior on scale { NumberAnimation { duration: 110; easing.type: Easing.OutQuad } }

        // Corner triangle accent
        Item {
            x: card.width - tile.cornerSize - 3
            y: 3
            width: tile.cornerSize
            height: tile.cornerSize
            clip: true

            Rectangle {
                width: tile.cornerSize * Math.SQRT2
                height: width
                x: tile.cornerSize - width / 2
                y: -width / 2
                rotation: 45
                antialiasing: true
                color: tile.hot ? root.baAccent : "#DDF0FC"
            }
        }

        Kirigami.Icon {
            id: icon
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: Math.round(card.height * 0.13)
            width: Math.round(card.height * 0.42)
            height: width
            source: tile.iconSource
        }

        Text {
            anchors.top: icon.bottom
            anchors.topMargin: Kirigami.Units.smallSpacing
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: Kirigami.Units.smallSpacing
            anchors.rightMargin: Kirigami.Units.smallSpacing
            horizontalAlignment: Text.AlignHCenter
            text: tile.label
            color: root.baNavy
            wrapMode: Text.Wrap
            maximumLineCount: 2
            elide: Text.ElideRight
            font.pixelSize: Math.round(Kirigami.Units.gridUnit * 0.62)
            font.weight: Font.DemiBold
        }

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            height: 3
            radius: 1.5
            color: root.baAccent
            visible: tile.hot
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onEntered: tile.hovered()
        onClicked: tile.activated()
    }
}
