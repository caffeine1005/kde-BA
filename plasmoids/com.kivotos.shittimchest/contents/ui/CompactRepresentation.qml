import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami

Item {
    id: compact

    readonly property bool horizontal: Plasmoid.formFactor === PlasmaCore.Types.Horizontal
    readonly property bool vertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical
    readonly property bool wide: horizontal && Plasmoid.configuration.showText && height >= Kirigami.Units.gridUnit * 1.5
    readonly property real skew: wide ? height * 0.3 : 0
    readonly property bool hot: mouse.containsMouse || root.expanded
    readonly property int buttonWidth: Math.round(wide ? height * 3.8 : height * 1.25)
    property bool wasExpanded: false

    Layout.minimumWidth: horizontal ? buttonWidth : Kirigami.Units.iconSizes.small
    Layout.preferredWidth: horizontal ? buttonWidth : -1
    Layout.minimumHeight: vertical ? Math.round(width * 0.8) : Kirigami.Units.iconSizes.small
    Layout.preferredHeight: vertical ? Math.round(width * 0.8) : -1

    SlantedRect {
        id: plate
        anchors.fill: parent
        anchors.topMargin: compact.wide ? Math.round(compact.height * 0.06) : 0
        anchors.bottomMargin: anchors.topMargin
        skew: compact.skew
        radius: compact.wide ? 0 : height * 0.2
        strokeColor: root.expanded ? root.baYellow : Qt.rgba(1, 1, 1, 0.9)
        strokeWidth: root.expanded ? 2 : 1
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: compact.hot ? "#6FCBFF" : "#47B6FA" }
            GradientStop { position: 1.0; color: compact.hot ? "#2E92F0" : "#1E7FE0" }
        }
        scale: mouse.pressed ? 0.96 : 1
        Behavior on scale { NumberAnimation { duration: 100 } }
    }

    // Two light stripes parallel to the right edge, like the in-game buttons.
    Repeater {
        model: compact.wide ? 2 : 0

        SlantedRect {
            y: plate.y
            height: plate.height
            width: compact.skew + 3
            skew: compact.skew
            x: plate.width - compact.skew - (index + 1) * compact.skew * 0.55 - 4
            fillColor: Qt.rgba(1, 1, 1, index === 0 ? 0.28 : 0.16)
            strokeWidth: 0
        }
    }

    RowLayout {
        anchors.fill: plate
        anchors.leftMargin: compact.wide ? compact.skew * 0.9 : 0
        anchors.rightMargin: compact.wide ? compact.skew * 1.6 : 0
        spacing: Math.round(plate.height * 0.16)

        Item {
            visible: !compact.wide
            Layout.fillWidth: true
        }

        TabletGlyph {
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredHeight: Math.round(plate.height * (compact.wide ? 0.52 : 0.6))
            Layout.preferredWidth: Math.round(Layout.preferredHeight * 1.38)
        }

        ColumnLayout {
            visible: compact.wide
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 0

            Text {
                Layout.fillWidth: true
                text: "SHITTIM CHEST"
                color: "white"
                font.pixelSize: Math.round(plate.height * 0.3)
                font.weight: Font.Black
                font.italic: true
                fontSizeMode: Text.HorizontalFit
                minimumPixelSize: 8
            }

            Text {
                Layout.fillWidth: true
                text: "A.R.O.N.A  SYSTEM"
                color: "#DDF3FF"
                font.pixelSize: Math.round(plate.height * 0.15)
                font.weight: Font.Bold
                font.letterSpacing: 1
                fontSizeMode: Text.HorizontalFit
                minimumPixelSize: 6
            }
        }

        Item {
            visible: !compact.wide
            Layout.fillWidth: true
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onPressed: compact.wasExpanded = root.expanded
        onClicked: root.expanded = !compact.wasExpanded
    }
}
