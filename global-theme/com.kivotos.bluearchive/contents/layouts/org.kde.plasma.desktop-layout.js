// Blue Archive home-screen layout:
//   top    - Sensei profile (left) ... AP / Credits / Pyroxene + system tray (right)
//   bottom - pinned apps, with the Shittim Chest launcher in the "Campaign" button spot

var desktopsArray = desktopsForActivity(currentActivity());
for (var j = 0; j < desktopsArray.length; j++) {
    desktopsArray[j].wallpaperPlugin = "org.kde.image";
}

var topBar = new Panel;
topBar.location = "top";
topBar.height = 2 * Math.floor(gridUnit * 2.4 / 2);
try { topBar.floating = false; } catch (e) {}

topBar.addWidget("com.kivotos.senseiprofile");
topBar.addWidget("org.kde.plasma.panelspacer");
topBar.addWidget("com.kivotos.resources");
topBar.addWidget("org.kde.plasma.marginsseparator");
topBar.addWidget("org.kde.plasma.systemtray");

var dock = new Panel;
dock.location = "bottom";
dock.height = 2 * Math.floor(gridUnit * 3.6 / 2);
try { dock.floating = true; } catch (e) {}

// Keep the tray a sensible width on ultrawide screens
var maximumAspectRatio = 21 / 9;
if (dock.formFactor === "horizontal") {
    var geo = screenGeometry(dock.screen);
    var maximumWidth = Math.ceil(geo.height * maximumAspectRatio);
    if (geo.width > maximumWidth) {
        dock.alignment = "center";
        dock.minimumLength = maximumWidth;
        dock.maximumLength = maximumWidth;
    }
}

var tasks = dock.addWidget("org.kde.plasma.icontasks");
tasks.currentConfigGroup = ["General"];
tasks.writeConfig("launchers", [
    "preferred://filemanager",
    "preferred://browser",
    "applications:org.kde.konsole.desktop",
    "applications:systemsettings.desktop"
]);

dock.addWidget("org.kde.plasma.marginsseparator");

var chest = dock.addWidget("com.kivotos.shittimchest");
chest.currentConfigGroup = ["Shortcuts"];
chest.writeConfig("global", "Alt+F1");
