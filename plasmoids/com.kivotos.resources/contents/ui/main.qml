import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as P5Support
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    property date now: new Date()
    property bool wasExpanded: false

    readonly property var battery: powerSource.data["Battery"] || ({})
    readonly property bool hasBattery: !!battery["Has Battery"]
    readonly property int batteryPercent: battery["Percent"] || 0

    preferredRepresentation: compactRepresentation
    hideOnWindowDeactivate: true
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    Plasmoid.icon: "view-calendar"

    toolTipMainText: Qt.locale().toString(now, Locale.LongFormat)
    toolTipSubText: hasBattery
        ? i18n("AP is your battery charge. Credits keep time, Pyroxene opens the calendar.")
        : i18n("Plugged into the Kivotos grid: AP stays full. Credits keep time, Pyroxene opens the calendar.")

    function run(cmd) {
        executable.connectSource(cmd);
    }

    function toggleCalendar() {
        root.expanded = !root.wasExpanded;
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: root.now = new Date()
    }

    P5Support.DataSource {
        id: powerSource
        engine: "powermanagement"
        connectedSources: ["Battery"]
    }

    P5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: (sourceName, data) => disconnectSource(sourceName)
    }

    compactRepresentation: Item {
        id: bar

        readonly property real pillHeight: Math.min(height, Kirigami.Units.gridUnit * 1.8)

        Layout.minimumWidth: pills.implicitWidth
        Layout.preferredWidth: pills.implicitWidth

        Row {
            id: pills
            anchors.verticalCenter: parent.verticalCenter
            spacing: Kirigami.Units.largeSpacing

            ResourcePill {
                height: bar.pillHeight
                kind: "ap"
                text: root.hasBattery ? root.batteryPercent + "/100" : "MAX"
                onBodyClicked: root.run("systemsettings kcm_powerdevilprofilesconfig")
                onPlusClicked: root.run("systemsettings kcm_powerdevilprofilesconfig")
            }

            ResourcePill {
                height: bar.pillHeight
                kind: "credit"
                text: Qt.formatTime(root.now, Qt.locale().timeFormat(Locale.ShortFormat))
                onBodyClicked: root.run("systemsettings kcm_clock")
                onPlusClicked: root.run("systemsettings kcm_clock")
            }

            ResourcePill {
                height: bar.pillHeight
                kind: "pyroxene"
                text: Qt.locale().toString(root.now, "ddd d MMM")
                onBodyPressed: root.wasExpanded = root.expanded
                onBodyClicked: root.toggleCalendar()
                onPlusClicked: root.toggleCalendar()
            }
        }
    }

    fullRepresentation: Item {
        Layout.preferredWidth: Kirigami.Units.gridUnit * 22
        Layout.preferredHeight: Kirigami.Units.gridUnit * 22
        Layout.minimumWidth: Kirigami.Units.gridUnit * 18
        Layout.minimumHeight: Kirigami.Units.gridUnit * 18

        Loader {
            id: calendarLoader
            anchors.fill: parent
            source: "CalendarView.qml"
        }

        Text {
            anchors.centerIn: parent
            visible: calendarLoader.status === Loader.Error
            text: Qt.locale().toString(root.now, Locale.LongFormat)
            color: Kirigami.Theme.textColor
        }
    }
}
