import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

Item {
    id: full

    readonly property real unit: Kirigami.Units.gridUnit
    readonly property bool searching: searchBox.text.length > 0
    readonly property var appsModel: searching ? root.searchModel : root.categoryModel

    Layout.preferredWidth: unit * 42
    Layout.preferredHeight: unit * 30
    Layout.minimumWidth: unit * 32
    Layout.minimumHeight: unit * 24

    function reset() {
        searchBox.text = "";
        root.categoryIndex = 0;
        appGrid.currentIndex = 0;
        appGrid.positionViewAtBeginning();
        categoryList.positionViewAtBeginning();
        searchBox.focusInput();
    }

    function opened() {
        reset();
        if (Plasmoid.configuration.bootAnimation) {
            bootOverlay.play();
        }
    }

    function launchAt(row) {
        if (!appsModel || appGrid.count === 0) {
            return;
        }
        root.launch(appsModel, Math.max(0, Math.min(row, appGrid.count - 1)));
    }

    Component.onCompleted: {
        if (root.expanded) {
            Qt.callLater(opened);
        }
    }

    Connections {
        target: root
        function onExpandedChanged() {
            if (root.expanded) {
                full.opened();
            } else {
                bootOverlay.stop();
            }
        }
    }

    SkyBackdrop {
        anchors.fill: parent
        radius: 10
        animate: root.expanded
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.largeSpacing * 1.5
        spacing: Kirigami.Units.largeSpacing

        // OS status bar
        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.largeSpacing

            TabletGlyph {
                Layout.preferredWidth: Math.round(full.unit * 2)
                Layout.preferredHeight: Math.round(full.unit * 1.45)
            }

            ColumnLayout {
                spacing: 0

                Text {
                    text: "SHITTIM CHEST"
                    color: "white"
                    font.pixelSize: Math.round(full.unit * 1.2)
                    font.weight: Font.Black
                    font.italic: true
                    font.letterSpacing: 1
                }

                Text {
                    text: "シッテムの箱  ·  A.R.O.N.A. OS"
                    color: "#E6F6FF"
                    font.pixelSize: Math.round(full.unit * 0.62)
                    font.weight: Font.DemiBold
                    font.letterSpacing: 1
                }
            }

            Item { Layout.fillWidth: true }

            Row {
                Layout.alignment: Qt.AlignVCenter
                spacing: 2

                Repeater {
                    model: 4

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: 3
                        height: 5 + index * 3
                        radius: 1
                        color: "white"
                    }
                }
            }

            Text {
                text: Qt.formatTime(root.now, Qt.locale().timeFormat(Locale.ShortFormat))
                color: "white"
                font.pixelSize: Math.round(full.unit * 0.9)
                font.weight: Font.Bold
            }
        }

        // A.R.O.N.A. greeting + search
        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.largeSpacing

            Rectangle {
                Layout.preferredWidth: Math.round(full.unit * 2.8)
                Layout.preferredHeight: Layout.preferredWidth
                radius: width / 2
                color: "white"
                border.color: root.baAccent
                border.width: 2

                Halo {
                    anchors.centerIn: parent
                    width: parent.width * 0.7
                    height: width
                    color: root.baAccent
                    spinning: root.expanded
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: bubbleColumn.implicitHeight + Kirigami.Units.largeSpacing * 2

                Rectangle {
                    x: -5
                    anchors.verticalCenter: parent.verticalCenter
                    width: 12
                    height: 12
                    rotation: 45
                    color: "white"
                    antialiasing: true
                }

                Rectangle {
                    anchors.fill: parent
                    radius: 8
                    color: "white"
                }

                ColumnLayout {
                    id: bubbleColumn
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: Kirigami.Units.largeSpacing
                    anchors.rightMargin: Kirigami.Units.largeSpacing
                    spacing: 1

                    Text {
                        text: "A.R.O.N.A."
                        color: root.baAccent
                        font.pixelSize: Math.round(full.unit * 0.6)
                        font.weight: Font.Black
                        font.letterSpacing: 1.5
                    }

                    Text {
                        Layout.fillWidth: true
                        text: root.greeting()
                        color: root.baNavy
                        wrapMode: Text.WordWrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                        font.pixelSize: Math.round(full.unit * 0.75)
                        font.weight: Font.DemiBold
                    }
                }
            }

            SearchBox {
                id: searchBox
                Layout.preferredWidth: Math.round(full.unit * 14)
                Layout.preferredHeight: Math.round(full.unit * 2.2)

                onTextChanged: {
                    root.runnerModel.query = text;
                    appGrid.currentIndex = 0;
                }
                onAccepted: full.launchAt(appGrid.currentIndex)
                onDownPressed: appGrid.forceActiveFocus()
                onEscapePressed: root.expanded = false
            }
        }

        // Categories + apps
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Kirigami.Units.largeSpacing

            ListView {
                id: categoryList
                Layout.preferredWidth: Math.round(full.unit * 10)
                Layout.fillHeight: true
                clip: true
                spacing: Kirigami.Units.smallSpacing
                boundsBehavior: Flickable.StopAtBounds
                model: root.rootModel

                delegate: CategoryTab {
                    width: categoryList.width
                    label: model.display || ""
                    iconSource: model.decoration
                    selected: !full.searching && index === root.categoryIndex
                    onClicked: {
                        searchBox.text = "";
                        root.categoryIndex = index;
                        appGrid.currentIndex = 0;
                        appGrid.positionViewAtBeginning();
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 8
                color: Qt.rgba(1, 1, 1, 0.38)
                border.color: Qt.rgba(1, 1, 1, 0.85)
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.largeSpacing
                    spacing: Kirigami.Units.smallSpacing

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Kirigami.Units.smallSpacing

                        Rectangle {
                            Layout.preferredWidth: 4
                            Layout.preferredHeight: Math.round(full.unit * 0.9)
                            radius: 1
                            color: root.baAccent
                        }

                        Text {
                            Layout.fillWidth: true
                            text: full.searching ? i18n("Search results") : root.categoryName
                            color: root.baNavy
                            elide: Text.ElideRight
                            font.pixelSize: Math.round(full.unit * 0.85)
                            font.weight: Font.Black
                            font.italic: true
                        }

                        Text {
                            text: i18np("%1 app", "%1 apps", appGrid.count)
                            color: root.baMuted
                            font.pixelSize: Math.round(full.unit * 0.65)
                            font.weight: Font.DemiBold
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        GridView {
                            id: appGrid

                            readonly property int columns: Math.max(1, Math.floor(width / (full.unit * 6)))

                            anchors.fill: parent
                            clip: true
                            cellWidth: Math.floor(width / columns)
                            cellHeight: Math.round(full.unit * 6)
                            boundsBehavior: Flickable.StopAtBounds
                            keyNavigationEnabled: true
                            model: full.appsModel

                            delegate: AppTile {
                                label: model.display || ""
                                iconSource: model.decoration
                                subtitle: model.description || ""
                                onActivated: full.launchAt(index)
                                onHovered: appGrid.currentIndex = index
                            }

                            Keys.onPressed: event => {
                                const code = event.text.length === 1 ? event.text.charCodeAt(0) : 0;
                                const modified = event.modifiers & (Qt.ControlModifier | Qt.AltModifier | Qt.MetaModifier);
                                if (code >= 32 && code !== 127 && !modified) {
                                    searchBox.text += event.text;
                                    searchBox.focusInput();
                                    event.accepted = true;
                                }
                            }
                            Keys.onReturnPressed: full.launchAt(currentIndex)
                            Keys.onEnterPressed: full.launchAt(currentIndex)
                            Keys.onEscapePressed: root.expanded = false
                            Keys.onUpPressed: {
                                if (currentIndex < columns) {
                                    searchBox.focusInput();
                                } else {
                                    moveCurrentIndexUp();
                                }
                            }
                        }

                        Column {
                            anchors.centerIn: parent
                            visible: appGrid.count === 0
                            spacing: Kirigami.Units.smallSpacing

                            Halo {
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: Math.round(full.unit * 2.5)
                                height: width
                                color: root.baAccent
                                opacity: 0.6
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: full.searching ? i18n("A.R.O.N.A. couldn't find that, Sensei…") : i18n("Loading the Shittim Chest…")
                                color: root.baNavy
                                font.pixelSize: Math.round(full.unit * 0.75)
                                font.weight: Font.DemiBold
                            }
                        }
                    }
                }
            }
        }

        // Sensei + session controls
        RowLayout {
            Layout.fillWidth: true
            spacing: Kirigami.Units.largeSpacing

            Kirigami.Avatar {
                Layout.preferredWidth: Math.round(full.unit * 2.2)
                Layout.preferredHeight: Layout.preferredWidth
                source: root.user.faceIconUrl
                name: root.senseiName
            }

            ColumnLayout {
                spacing: 0

                Text {
                    text: root.senseiName
                    color: root.baNavy
                    font.pixelSize: Math.round(full.unit * 0.85)
                    font.weight: Font.Black
                }

                Text {
                    text: i18n("Sensei · S.C.H.A.L.E Office")
                    color: root.baMuted
                    font.pixelSize: Math.round(full.unit * 0.6)
                    font.weight: Font.DemiBold
                }
            }

            Item { Layout.fillWidth: true }

            PowerButton {
                label: i18n("Lock")
                iconName: "system-lock-screen"
                onClicked: root.runCommand("loginctl lock-session")
            }

            PowerButton {
                label: i18n("Log Out")
                iconName: "system-log-out"
                onClicked: root.logoutPrompt("promptLogout")
            }

            PowerButton {
                label: i18n("Restart")
                iconName: "system-reboot"
                onClicked: root.logoutPrompt("promptReboot")
            }

            PowerButton {
                label: i18n("Shut Down")
                iconName: "system-shutdown"
                primary: true
                onClicked: root.logoutPrompt("promptShutDown")
            }
        }
    }

    BootOverlay {
        id: bootOverlay
        anchors.fill: parent
    }
}
