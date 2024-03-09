import QtQuick
import QtQuick.Effects

Item {
    id: wPopUp
    z: 10
    opacity: 0
    property bool autohide: true
    width: 400
    height: 200
    visible: false
    property alias text: wPopUpText

    signal hidden()

    function show(text = "") {
        wPopUpText.text = text
        visible = true
        if (autohide) wPopUpShowHideAnimation.restart()
        else wPopUpShowAnimation.restart()
        wPopUpMA.enabled = true
    }

    function hide() {
        if (wPopUp.autohide) wPopUpShowHideAnimation.stop()
        else wPopUpShowAnimation.stop()
        wPopUpHideAnimation.start()
    }

    Component.onCompleted: {
        wPopUpHideAnimation.finished.connect(hidden)
        wPopUpShowHideAnimation.finished.connect(hidden)
    }

    Rectangle {
        id: wPopUpRect
        anchors.centerIn: parent
        radius: 20
        property real sizeMod: 0.9
        width: wPopUp.width * sizeMod
        height: wPopUp.height * sizeMod
        color: "white"

        MouseArea {
            id: wPopUpMA
            enabled: false
            anchors.fill: parent
            onClicked: {
                wPopUp.hide()
            }
        }

        Text {
            id: wPopUpText
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
        id: wPopUpShowHideAnimation

        ParallelAnimation {

            PropertyAnimation {
                target: wPopUpRect
                property: "sizeMod"
                to: 1
                duration: 300
                easing.type: Easing.InOutQuad
            }

            PropertyAnimation {
                target: wPopUp
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
                    target: wPopUpRect
                    property: "sizeMod"
                    to: 0.9
                    duration: 300
                    easing.type: Easing.InOutQuad
                }

                PropertyAnimation {
                    target: wPopUp
                    property: "opacity"
                    to: 0
                    duration: 300
                    easing.type: Easing.InOutQuad
                }
            }

            PropertyAction {
                target: wPopUpMA
                property: "enabled"
                value: false
            }

            PropertyAction {
                target: wPopUp
                property: "visible"
                value: false
            }
        }
    }

    SequentialAnimation {
        id: wPopUpShowAnimation

        ParallelAnimation {

            PropertyAnimation {
                target: wPopUpRect
                property: "sizeMod"
                to: 1
                duration: 300
                easing.type: Easing.InOutQuad
            }

            PropertyAnimation {
                target: wPopUp
                property: "opacity"
                to: 1
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }

        PropertyAction {
            target: wPopUpMA
            property: "enabled"
            value: true
        }
    }

    SequentialAnimation {
        id: wPopUpHideAnimation

        ParallelAnimation {

            PropertyAnimation {
                target: wPopUpRect
                property: "sizeMod"
                to: 0.9
                duration: 300
                easing.type: Easing.InOutQuad
            }

            PropertyAnimation {
                target: wPopUp
                property: "opacity"
                to: 0
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }

        PropertyAction {
            target: wPopUpMA
            property: "enabled"
            value: false
        }

        PropertyAction {
            target: wPopUp
            property: "visible"
            value: false
        }
    }

    MultiEffect {
        source: wPopUpRect
        anchors.fill: wPopUpRect
        shadowEnabled: true
        shadowBlur: 1
        shadowScale: 1
        shadowColor: 'black'
        shadowOpacity: 0.3
        shadowVerticalOffset: 3
    }
}

