import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property alias cfg_senseiName: senseiName.text
    property alias cfg_bootAnimation: bootAnimation.checked
    property alias cfg_showText: showText.checked

    Kirigami.FormLayout {
        QQC2.TextField {
            id: senseiName
            Kirigami.FormData.label: i18n("Sensei name:")
            placeholderText: i18n("Use my account name")
        }

        QQC2.CheckBox {
            id: bootAnimation
            Kirigami.FormData.label: i18n("Opening:")
            text: i18n("Play the Shittim Chest boot animation")
        }

        QQC2.CheckBox {
            id: showText
            Kirigami.FormData.label: i18n("Panel button:")
            text: i18n("Show the \"Shittim Chest\" label")
        }
    }
}
