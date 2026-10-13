import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as P5Support
import org.kde.kirigami as Kirigami
import org.kde.coreaddons as KCoreAddons

PlasmoidItem {
    id: root

    readonly property string uptimeCommand: "cat /proc/uptime"
    readonly property int maxLevel: 90
    property int uptimeSeconds: 0
    readonly property int hours: Math.floor(uptimeSeconds / 3600)
    readonly property bool maxed: hours + 1 >= maxLevel
    readonly property int level: Math.min(maxLevel, hours + 1)
    readonly property int exp: Math.floor((uptimeSeconds % 3600) / 60)

    property QtObject user: KCoreAddons.KUser {}
    readonly property string senseiName: Plasmoid.configuration.senseiName || user.fullName || user.loginName

    preferredRepresentation: fullRepresentation
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    Plasmoid.icon: "user-identity"

    toolTipMainText: i18n("%1 · Lv. %2", senseiName, level)
    toolTipSubText: i18n("Sensei gains a level for every hour the Shittim Chest stays on.")

    P5Support.DataSource {
        id: uptimeSource
        engine: "executable"
        connectedSources: []
        onNewData: (sourceName, data) => {
            const seconds = parseFloat(String(data["stdout"] || "").split(" ")[0]);
            if (!isNaN(seconds)) {
                root.uptimeSeconds = Math.floor(seconds);
            }
            disconnectSource(sourceName);
        }
    }

    P5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: (sourceName, data) => disconnectSource(sourceName)
    }

    Timer {
        interval: 60000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: uptimeSource.connectSource(root.uptimeCommand)
    }

    fullRepresentation: MouseArea {
        id: profile

        readonly property bool vertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical
        readonly property real badgeSize: vertical ? width : Math.min(height, Kirigami.Units.gridUnit * 2.4) * 0.88

        Layout.minimumWidth: vertical ? -1 : row.implicitWidth
        Layout.preferredWidth: vertical ? -1 : row.implicitWidth
        Layout.minimumHeight: vertical ? width : -1
        Layout.preferredHeight: vertical ? width : -1

        hoverEnabled: true
        onClicked: executable.connectSource("systemsettings kcm_users")

        RowLayout {
            id: row
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: Kirigami.Units.smallSpacing * 2

            // Level badge
            Rectangle {
                Layout.preferredWidth: Math.round(profile.badgeSize)
                Layout.preferredHeight: Math.round(profile.badgeSize)
                radius: width / 2
                border.color: "white"
                border.width: 2
                gradient: Gradient {
                    GradientStop { position: 0.0; color: profile.containsMouse ? "#86DDFF" : "#5CC4FF" }
                    GradientStop { position: 1.0; color: "#1E7FE0" }
                }

                Column {
                    anchors.centerIn: parent
                    spacing: -Math.round(parent.height * 0.06)

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Lv."
                        color: "white"
                        font.pixelSize: Math.max(6, Math.round(profile.badgeSize * 0.22))
                        font.weight: Font.Bold
                        font.italic: true
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: root.level
                        color: "white"
                        font.pixelSize: Math.max(8, Math.round(profile.badgeSize * 0.4))
                        font.weight: Font.Black
                        font.italic: true
                    }
                }
            }

            ColumnLayout {
                visible: !profile.vertical
                spacing: 2

                Text {
                    text: root.senseiName
                    color: Kirigami.Theme.textColor
                    font.pixelSize: Math.max(10, Math.round(profile.badgeSize * 0.36))
                    font.weight: Font.Black
                }

                RowLayout {
                    spacing: Kirigami.Units.smallSpacing

                    Rectangle {
                        Layout.preferredWidth: Math.round(Kirigami.Units.gridUnit * 6)
                        Layout.preferredHeight: Math.max(4, Math.round(profile.badgeSize * 0.14))
                        radius: height / 2
                        color: Qt.rgba(0.17, 0.25, 0.36, 0.15)

                        Rectangle {
                            width: parent.width * (root.maxed ? 1 : root.exp / 60)
                            height: parent.height
                            radius: height / 2
                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop { position: 0.0; color: "#7DD8FF" }
                                GradientStop { position: 1.0; color: "#2CA0F0" }
                            }
                            Behavior on width { NumberAnimation { duration: 400 } }
                        }
                    }

                    Text {
                        text: root.maxed ? "MAX" : root.exp + "/60"
                        color: Kirigami.Theme.disabledTextColor
                        font.pixelSize: Math.max(7, Math.round(profile.badgeSize * 0.22))
                        font.weight: Font.Bold
                    }
                }
            }
        }
    }
}
