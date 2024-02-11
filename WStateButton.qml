import QtQuick
import QtQuick.Effects

Item {
    id: wButton
    property alias text: wButtonText.text
    property bool pressed
    height: 40
    width: 100
    signal clicked(var mouse)
    signal released
    function release() {
        if (pressed) {
            wButtonReleaseAnimation.restart()
            wButtonMA.hoverEnabled = true
            wButton.pressed = false
            wButton.released()
        }
    }

    Component.onCompleted: {
        wButtonMA.clicked.connect(clicked)
    }

    Rectangle {
        id: wButtonRect
        y: 0
        color: "#ffffff"
        height: wButton.height
        width: wButton.width
        radius: height / 2
        border.width: 0
        border.color: "#bbbbff"

        MouseArea {
            id: wButtonMA
            hoverEnabled: true
            anchors.fill: parent
            property bool hovered: false
            onEntered: {
                wButtonRect.border.width = 1
            }
            onExited: {
                if (wButtonMA.hoverEnabled) {
                    wButtonRect.border.width = 0
                }
            }
            onClicked: {
                wButton.pressed = true
                wButtonClickAnimation.restart()
                hoverEnabled = false
            }
        }

        Text {
            id: wButtonText
            property real defaultY: (parent.height - height) / 2
            y: defaultY
            anchors.horizontalCenter: parent.horizontalCenter
            color: constants.weakTextColor
            font {
                pixelSize: 20
                family: constants.fontFamily
                bold: true
            }
        }
    }

    ParallelAnimation {
        id: wButtonClickAnimation

        PropertyAnimation {
            target: wButtonText
            property: "color"
            to: constants.strongTextColor
            duration: 200
            easing.type: Easing.InOutQuad
        }

        PropertyAnimation {
            target: wButtonRect
            property: "border.width"
            to: 2
            duration: 200
            easing.type: Easing.InOutQuad
        }

        PropertyAnimation {
            target: wButtonRect
            property: "border.color"
            to: constants.weakTextColor
            duration: 200
            easing.type: Easing.InOutQuad
        }

        PropertyAnimation {
            target: wButtonShadow
            property: "shadowBlur"
            to: 0.1
            duration: 200
            easing.type: Easing.InOutQuad
        }

        PropertyAnimation {
            target: wButtonShadow
            property: "shadowScale"
            to: 0.95
            duration: 200
            easing.type: Easing.InOutQuad
        }

        PropertyAnimation {
            target: wButtonShadow
            property: "shadowVerticalOffset"
            to: 0
            duration: 200
            easing.type: Easing.InOutQuad
        }

        PropertyAnimation {
            target: wButtonShadow
            property: "shadowOpacity"
            to: 0.5
            duration: 200
            easing.type: Easing.InOutQuad
        }

        PropertyAnimation {
            target: wButtonRect
            property: "color"
            to: "#fafafa"
            duration: 200
            easing.type: Easing.InOutQuad
        }

        PropertyAnimation {
            target: wButtonRect
            property: "y"
            to: 3
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }

    ParallelAnimation {
        id: wButtonReleaseAnimation

        PropertyAnimation {
            target: wButtonText
            property: "color"
            to: constants.weakTextColor
            duration: 200
            easing.type: Easing.InOutQuad
        }

        PropertyAnimation {
            target: wButtonRect
            property: "border.width"
            to: 0
            duration: 200
            easing.type: Easing.InOutQuad
        }

        PropertyAnimation {
            target: wButtonRect
            property: "border.color"
            to: "#bbbbff"
            duration: 200
            easing.type: Easing.InOutQuad
        }

        NumberAnimation {
            target: wButtonShadow
            property: "shadowBlur"
            to: 0.3
            duration: 200
            easing.type: Easing.InOutQuad
        }

        NumberAnimation {
            target: wButtonShadow
            property: "shadowScale"
            to: 1
            duration: 200
            easing.type: Easing.InOutQuad
        }

        NumberAnimation {
            target: wButtonShadow
            property: "shadowVerticalOffset"
            to: 3
            duration: 200
            easing.type: Easing.InOutQuad
        }

        NumberAnimation {
            target: wButtonShadow
            property: "shadowOpacity"
            to: 0.3
            duration: 200
            easing.type: Easing.InOutQuad
        }

        PropertyAnimation {
            target: wButtonRect
            property: "color"
            to: "#ffffff"
            duration: 200
            easing.type: Easing.InOutQuad
        }

        NumberAnimation {
            target: wButtonRect
            property: "y"
            to: 0
            duration: 200
            easing.type: Easing.InOutQuad
        }
    }


    MultiEffect {
        id: wButtonShadow
        source: wButtonRect
        anchors.fill: wButtonRect
        shadowEnabled: true
        shadowBlur: 0.3
        shadowScale: 1
        shadowColor: 'black'
        shadowOpacity: 0.3
        shadowVerticalOffset: 3
    }
}
