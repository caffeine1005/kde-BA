import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as P5Support
import org.kde.kirigami as Kirigami
import org.kde.coreaddons as KCoreAddons
import org.kde.plasma.private.kicker as Kicker

PlasmoidItem {
    id: root

    readonly property color baNavy: "#2B3F5C"
    readonly property color baMuted: "#6B7F99"
    readonly property color baAccent: "#2CA0F0"
    readonly property color baAccentDeep: "#1E7FE0"
    readonly property color baLine: "#CBE6F8"
    readonly property color baYellow: "#FFE14A"

    property int categoryIndex: 0
    property int modelRevision: 0
    property date now: new Date()
    property int greetingSeed: 0

    property QtObject user: KCoreAddons.KUser {}
    readonly property string senseiName: Plasmoid.configuration.senseiName || user.fullName || user.loginName

    property alias rootModel: rootModelItem
    property alias runnerModel: runnerModelItem

    readonly property var categoryModel: {
        modelRevision;
        if (rootModelItem.count <= 0) {
            return null;
        }
        return rootModelItem.modelForRow(Math.min(categoryIndex, rootModelItem.count - 1));
    }

    readonly property string categoryName: {
        modelRevision;
        if (rootModelItem.count <= 0) {
            return "";
        }
        return rootModelItem.data(rootModelItem.index(Math.min(categoryIndex, rootModelItem.count - 1), 0), Qt.DisplayRole) || "";
    }

    readonly property var searchModel: runnerModelItem.count > 0 ? runnerModelItem.modelForRow(0) : null

    Plasmoid.icon: "input-tablet"
    toolTipMainText: i18n("Shittim Chest")
    toolTipSubText: i18n("A.R.O.N.A. is standing by, Sensei.")

    preferredRepresentation: compactRepresentation
    hideOnWindowDeactivate: true
    compactRepresentation: CompactRepresentation {}
    fullRepresentation: FullRepresentation {}

    onExpandedChanged: {
        if (expanded) {
            now = new Date();
            greetingSeed = Math.floor(Math.random() * 1000);
        }
    }

    function greeting() {
        const h = now.getHours();
        let lines;
        if (h < 5) {
            lines = [
                i18n("Sensei… it's really late. Please don't stay up too long, okay?"),
                i18n("Zzz… Ah! Sensei! I wasn't sleeping, I promise!")
            ];
        } else if (h < 11) {
            lines = [
                i18n("Good morning, Sensei! Let's do our best today!"),
                i18n("Morning, Sensei! I've already sorted today's tasks~")
            ];
        } else if (h < 14) {
            lines = [
                i18n("Sensei, have you had lunch yet? Strawberry milk counts, right?"),
                i18n("Welcome back, Sensei! What shall we work on?")
            ];
        } else if (h < 18) {
            lines = [
                i18n("The students are counting on you this afternoon, Sensei!"),
                i18n("Sensei, don't forget to take a short break, okay?")
            ];
        } else {
            lines = [
                i18n("Good evening, Sensei. Thank you for your hard work today!"),
                i18n("Sensei, shall we wrap up today's paperwork?")
            ];
        }
        return lines[greetingSeed % lines.length];
    }

    function launch(model, row) {
        if (model && row >= 0) {
            model.trigger(row, "", null);
        }
        root.expanded = false;
    }

    function runCommand(cmd) {
        executable.connectSource(cmd);
        root.expanded = false;
    }

    function logoutPrompt(method) {
        runCommand("dbus-send --session --type=method_call --dest=org.kde.LogoutPrompt /LogoutPrompt org.kde.LogoutPrompt." + method);
    }

    Timer {
        interval: 10000
        repeat: true
        running: root.expanded
        onTriggered: root.now = new Date()
    }

    Kicker.RootModel {
        id: rootModelItem

        autoPopulate: false
        appletInterface: root
        flat: true
        sorted: true
        showSeparators: false
        showAllApps: true
        showRecentApps: false
        showRecentDocs: false
        showPowerSession: false

        Component.onCompleted: refresh()
    }

    Connections {
        target: rootModelItem
        ignoreUnknownSignals: true
        function onRefreshed() {
            root.modelRevision++;
        }
    }

    Kicker.RunnerModel {
        id: runnerModelItem

        appletInterface: root
        mergeResults: true
        runners: [
            "krunner_services",
            "krunner_systemsettings",
            "krunner_sessions",
            "krunner_powerdevil",
            "calculator",
            "unitconverter"
        ]
    }

    P5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: (sourceName, data) => disconnectSource(sourceName)
    }
}
