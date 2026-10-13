import QtQuick

// The space inside the Shittim Chest: open sky over a still, reflective water floor.
Item {
    id: sky

    property real radius: 10
    property real horizon: 0.82
    property bool animate: false

    clip: true

    component Cloud: Item {
        id: cloud

        property real baseX: 0
        property real drift: 0
        property int period: 9000
        property bool animate: false

        x: baseX + drift
        height: width * 0.3
        opacity: 0.8
        layer.enabled: true

        Rectangle {
            y: cloud.height * 0.4
            width: cloud.width
            height: cloud.height * 0.6
            radius: height / 2
            color: "white"
        }
        Rectangle {
            x: cloud.width * 0.16
            y: cloud.height * 0.12
            width: cloud.width * 0.38
            height: cloud.height * 0.8
            radius: height / 2
            color: "white"
        }
        Rectangle {
            x: cloud.width * 0.42
            width: cloud.width * 0.36
            height: cloud.height * 0.92
            radius: height / 2
            color: "white"
        }

        SequentialAnimation on drift {
            running: cloud.animate
            loops: Animation.Infinite
            NumberAnimation { to: 18; duration: cloud.period; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0; duration: cloud.period; easing.type: Easing.InOutSine }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: sky.radius
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#3FA9F5" }
            GradientStop { position: 0.42; color: "#86CEFA" }
            GradientStop { position: sky.horizon; color: "#DDF2FF" }
            GradientStop { position: 1.0; color: "#DDF2FF" }
        }
    }

    // Sun glow
    Repeater {
        model: 3

        Rectangle {
            readonly property real size: sky.height * (0.35 + index * 0.22)
            width: size
            height: size
            radius: size / 2
            x: sky.width * 0.82 - size / 2
            y: sky.height * 0.04 - size / 2
            color: "white"
            opacity: 0.16
        }
    }

    // Light beams
    Repeater {
        model: [
            { "x": 0.52, "w": 0.07 },
            { "x": 0.63, "w": 0.035 },
            { "x": 0.71, "w": 0.11 }
        ]

        Rectangle {
            x: sky.width * modelData.x
            y: -sky.height * 0.1
            width: sky.width * modelData.w
            height: sky.height * 1.3
            rotation: 28
            transformOrigin: Item.Top
            opacity: 0.18
            gradient: Gradient {
                GradientStop { position: 0.0; color: "white" }
                GradientStop { position: 0.8; color: Qt.rgba(1, 1, 1, 0) }
            }
        }
    }

    Halo {
        x: sky.width * 0.74
        y: sky.height * 0.06
        width: sky.height * 0.42
        height: width
        color: "white"
        opacity: 0.22
        spinning: sky.animate
    }

    Cloud { animate: sky.animate; baseX: sky.width * 0.04; y: sky.height * 0.30; width: sky.width * 0.22; period: 9000 }
    Cloud { animate: sky.animate; baseX: sky.width * 0.55; y: sky.height * 0.20; width: sky.width * 0.18; period: 11000 }
    Cloud { animate: sky.animate; baseX: sky.width * 0.30; y: sky.height * 0.52; width: sky.width * 0.26; period: 13000 }
    Cloud { animate: sky.animate; baseX: sky.width * 0.70; y: sky.height * 0.60; width: sky.width * 0.24; period: 10000 }

    // Water floor
    Rectangle {
        anchors.fill: parent
        radius: sky.radius
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0) }
            GradientStop { position: sky.horizon; color: Qt.rgba(1, 1, 1, 0) }
            GradientStop { position: sky.horizon + 0.001; color: "#C4E8FF" }
            GradientStop { position: 1.0; color: "#A2D8FA" }
        }
    }

    Rectangle {
        y: sky.height * sky.horizon
        width: sky.width
        height: 1.5
        color: "white"
        opacity: 0.9
    }

    // Ripples
    Repeater {
        model: 5

        Rectangle {
            x: sky.width * (0.08 + 0.17 * ((index * 3) % 5))
            y: sky.height * (sky.horizon + (1 - sky.horizon) * (index + 1) / 6)
            width: sky.width * (0.1 + 0.03 * index)
            height: 2
            radius: 1
            color: "white"
            opacity: 0.55 - index * 0.07
        }
    }
}
