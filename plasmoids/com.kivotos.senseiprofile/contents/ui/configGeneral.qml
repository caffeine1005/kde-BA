import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property alias cfg_senseiName: senseiName.text

    Kirigami.FormLayout {
        QQC2.TextField {
            id: senseiName
            Kirigami.FormData.label: i18n("Sensei name:")
            placeholderText: i18n("Use my account name")
        }
    }
}
