import QtQuick
import QtQuick.Effects

Item {
    id: wPopUp
    z: 10
    opacity: 0
    property bool autohide: true
    width: popUpText.width + 150
    height: popUpText.height + 100
    visible: false
    property alias text: popUpText

    signal hidden()

    function show(text = "") {
        popUpText.text = text
        visible = true
        if (autohide) wPopUpShowHideAnimation.restart()
        else wPopUpShowAnimation.restart()
        mouseArea.enabled = true
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
        id: mainRect
        anchors.centerIn: parent
        radius: 20
        property real sizeMod: 0.9
        width: wPopUp.width * sizeMod
        height: wPopUp.height * sizeMod
        color: "white"

        MouseArea {
            id: mouseArea
            enabled: false
            anchors.fill: parent
            onClicked: {
                wPopUp.hide()
            }
        }

        WText {
            id: popUpText
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: constants.fontSize * 1.3
        }
    }

    SequentialAnimation {
        id: wPopUpShowHideAnimation

        ParallelAnimation {

            PropertyAnimation {
                target: mainRect
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
                    target: mainRect
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
                target: mouseArea
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
                target: mainRect
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
            target: mouseArea
            property: "enabled"
            value: true
        }
    }

    SequentialAnimation {
        id: wPopUpHideAnimation

        ParallelAnimation {

            PropertyAnimation {
                target: mainRect
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
            target: mouseArea
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
        source: mainRect
        anchors.fill: mainRect
        shadowEnabled: true
        shadowBlur: 1
        shadowScale: 1
        shadowColor: 'black'
        shadowOpacity: 0.3
        shadowVerticalOffset: 3
    }
}

