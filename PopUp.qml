import QtQuick
import QtQuick.Effects

Item {
    id: popUp
    z: 10
    opacity: 0
    function show(text) {
        popUpText.text = text
        popUpAnimation.restart()
        popUpMA.enabled = true
    }

    Rectangle {
        id: popUpRect
        anchors.centerIn: parent
        radius: 20
        property real sizeMod: 0.9
        width: 400 * sizeMod
        height: 200 * sizeMod
        color: "white"

        MouseArea {
            id: popUpMA
            enabled: false
            anchors.fill: parent
            onClicked: {
                popUpAnimation.stop()
                popUpHideAnimation.start()
            }
        }

        Text {
            id: popUpText
            anchors.centerIn: parent
            color: constants.weakTextColor
            horizontalAlignment: Text.AlignHCenter
            font {
                family: constants.fontFamily
                bold: true
                pixelSize: 30
            }
        }
    }

    SequentialAnimation {
        id: popUpAnimation

        ParallelAnimation {

            PropertyAnimation {
                target: popUpRect
                property: "sizeMod"
                to: 1
                duration: 300
                easing.type: Easing.InOutQuad
            }

            PropertyAnimation {
                target: popUp
                property: "opacity"
                to: 1
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }

        PauseAnimation {
            duration: 1500
        }

        SequentialAnimation {

            ParallelAnimation {

                PropertyAnimation {
                    target: popUpRect
                    property: "sizeMod"
                    to: 0.9
                    duration: 300
                    easing.type: Easing.InOutQuad
                }

                PropertyAnimation {
                    target: popUp
                    property: "opacity"
                    to: 0
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }

            PropertyAction {
                target: popUpMA
                property: "enabled"
                value: false
            }
        }
    }

    SequentialAnimation {
        id: popUpHideAnimation

        ParallelAnimation {

            PropertyAnimation {
                target: popUpRect
                property: "sizeMod"
                to: 0.9
                duration: 300
                easing.type: Easing.InOutQuad
            }

            PropertyAnimation {
                target: popUp
                property: "opacity"
                to: 0
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }

        PropertyAction {
            target: popUpMA
            property: "enabled"
            value: false
        }
    }

    MultiEffect {
        source: popUpRect
        anchors.fill: popUpRect
        shadowEnabled: true
        shadowBlur: 1
        shadowScale: 1
        shadowColor: 'black'
        shadowOpacity: 0.3
        shadowVerticalOffset: 3
    }
}

