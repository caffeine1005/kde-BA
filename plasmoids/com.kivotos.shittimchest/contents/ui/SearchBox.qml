import QtQuick
import org.kde.kirigami as Kirigami

Rectangle {
    id: box

    property alias text: input.text

    signal accepted()
    signal downPressed()
    signal escapePressed()

    function focusInput() {
        input.forceActiveFocus();
    }

    radius: height / 2
    color: "white"
    border.width: input.activeFocus ? 2 : 1
    border.color: input.activeFocus ? root.baAccent : root.baLine

    Kirigami.Icon {
        id: searchIcon
        anchors.left: parent.left
        anchors.leftMargin: Math.round(box.height * 0.4)
        anchors.verticalCenter: parent.verticalCenter
        width: Kirigami.Units.iconSizes.small
        height: width
        source: "search"
        color: root.baAccent
        isMask: true
    }

    TextInput {
        id: input
        anchors.left: searchIcon.right
        anchors.right: clearButton.visible ? clearButton.left : parent.right
        anchors.leftMargin: Kirigami.Units.smallSpacing
        anchors.rightMargin: Math.round(box.height * 0.35)
        anchors.verticalCenter: parent.verticalCenter
        color: root.baNavy
        selectionColor: root.baAccent
        selectedTextColor: "white"
        selectByMouse: true
        clip: true
        font.pixelSize: Math.round(Kirigami.Units.gridUnit * 0.72)
        font.weight: Font.DemiBold

        Keys.onDownPressed: box.downPressed()
        Keys.onReturnPressed: box.accepted()
        Keys.onEnterPressed: box.accepted()
        Keys.onEscapePressed: event => {
            if (input.text.length > 0) {
                input.text = "";
            } else {
                box.escapePressed();
            }
            event.accepted = true;
        }
    }

    Text {
        anchors.fill: input
        verticalAlignment: Text.AlignVCenter
        visible: input.text.length === 0 && input.preeditText.length === 0
        text: i18n("Search the Shittim Chest…")
        color: root.baMuted
        elide: Text.ElideRight
        font: input.font
    }

    Kirigami.Icon {
        id: clearButton
        anchors.right: parent.right
        anchors.rightMargin: Math.round(box.height * 0.3)
        anchors.verticalCenter: parent.verticalCenter
        width: Kirigami.Units.iconSizes.small
        height: width
        visible: input.text.length > 0
        source: "edit-clear"
        color: root.baMuted
        isMask: true

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                input.text = "";
                input.forceActiveFocus();
            }
        }
    }
}
