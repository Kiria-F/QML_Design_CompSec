import QtQuick
import QtQuick.Effects

Item {
    id: wPlatform
    property alias color: wPlatformRect.color

    Rectangle {
        id: wPlatformRect
        anchors.fill: parent
        color: "white"
        radius: constants.radius
    }

    MultiEffect {
        id: wPlatfromShadow
        source: wPlatformRect
        anchors.fill: wPlatformRect
        shadowEnabled: true
        shadowBlur: 0.5
        shadowScale: 1
        shadowColor: 'black'
        shadowOpacity: 0.2
        shadowVerticalOffset: 3
    }
}
