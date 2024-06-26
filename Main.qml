import QtQuick
import QtQuick.Effects
import QtQuick.Controls

Window {
    visible: true
    title: qsTr("Computer Security Labs")

    Item {
        id: data
        visible: false
        property int labCount: 7
        property QtObject clickedButton
    }

    MultiEffect {
        id: topBarShadow
        source: topBarSelection
        anchors.fill: topBarSelection
        shadowEnabled: true
        shadowBlur: 0.5
        shadowScale: 1
        shadowColor: 'black'
        shadowOpacity: 0.3
        shadowVerticalOffset: 3
    }

    // Item {
    //     id: wSelector
    //     anchors.centerIn: parent
    //     property var model: [1, 2, 3, 4, 5]

    //     Row {
    //         spacing: 20
    //         anchors.centerIn: parent

    //         Repeater {
    //             model: wSelector.model

    //             WText {
    //                 id: wSelectorText
    //                 text: modelData
    //             }
    //         }
    //     }
    // }

    Rectangle {
        id: topBarSelection
        radius: height / 2
        height: topBar.height
        width: topBar.width
        x: topBar.x
        y: topBar.y

        Behavior on x {
            NumberAnimation {
                easing.type: Easing.InOutQuad
                duration: 100
            }
        }

        Behavior on width {
            NumberAnimation {
                easing.type: Easing.InOutQuad
                duration: 100
            }
        }
    }

    Rectangle {
        id: topBar
        property int numSpace: 15
        height: 40
        width: topBarRow.width + numSpace * 3
        color: "transparent"
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 10
        }

        MouseArea {
            hoverEnabled: true
            width: topBarRow.width
            height: topBar.height
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
            onExited: {
                topBarSelection.x = topBar.x
                topBarSelection.width = topBar.width
            }

            Row {
                id:topBarRow

                Repeater {
                    id: topBarRowRep
                    model: data.labCount

                    MouseArea {
                        id: topBarRowMA
                        hoverEnabled: true
                        height: topBar.height
                        width: topBarNumber.width + topBar.numSpace
                        property bool hovered: false
                        onEntered: {
                            topBarSelection.width = topBarSelection.height
                            topBarSelection.x = topBarRowMA.mapToGlobal(0, 0).x + width / 2 - topBarSelection.height / 2
                            topBarNumber.color = constants.strongTextColor
                        }
                        onExited: {
                            topBarNumber.color = constants.weakTextColor
                        }
                        onClicked: {
                            data.clickedButton = this
                            topBarClickAnimation.restart()
                            labStack.replace("Lab" + (index + 1) + ".qml")
                        }

                        Text {
                            id: topBarNumber
                            property int defaultY: (parent.height - height) / 2
                            y: defaultY
                            anchors.horizontalCenter: parent.horizontalCenter

                            color: constants.weakTextColor
                            font {
                                family: constants.fontFamily
                                bold: true
                                pixelSize: topBar.height / 2
                            }
                            text: index + 1
                        }

                        SequentialAnimation {
                            id: topBarClickAnimation

                            ParallelAnimation {

                                NumberAnimation {
                                    target: topBarShadow
                                    property: "shadowBlur"
                                    to: 0
                                    duration: 200
                                    easing.type: Easing.InOutQuad
                                }

                                NumberAnimation {
                                    target: topBarShadow
                                    property: "shadowVerticalOffset"
                                    to: 0
                                    duration: 200
                                    easing.type: Easing.InOutQuad
                                }

                                NumberAnimation {
                                    target: topBarShadow
                                    property: "shadowOpacity"
                                    to: 0.5
                                    duration: 200
                                    easing.type: Easing.InOutQuad
                                }

                                PropertyAnimation {
                                    target: topBarSelection
                                    property: "color"
                                    to: "#fafafa"
                                    duration: 200
                                    easing.type: Easing.InOutQuad
                                }

                                NumberAnimation {
                                    target: topBarSelection
                                    property: "y"
                                    to: topBar.y + 3
                                    duration: 200
                                    easing.type: Easing.InOutQuad
                                }

                                NumberAnimation {
                                    target: topBarNumber
                                    property: "y"
                                    to: topBarNumber.defaultY + 3
                                    duration: 200
                                    easing.type: Easing.InOutQuad
                                }
                            }

                            ParallelAnimation {

                                NumberAnimation {
                                    target: topBarShadow
                                    property: "shadowBlur"
                                    to: 0.5
                                    duration: 200
                                    easing.type: Easing.InOutQuad
                                }

                                NumberAnimation {
                                    target: topBarShadow
                                    property: "shadowVerticalOffset"
                                    to: 3
                                    duration: 200
                                    easing.type: Easing.InOutQuad
                                }

                                NumberAnimation {
                                    target: topBarShadow
                                    property: "shadowOpacity"
                                    to: 0.3
                                    duration: 200
                                    easing.type: Easing.InOutQuad
                                }

                                PropertyAnimation {
                                    target: topBarSelection
                                    property: "color"
                                    to: "#ffffff"
                                    duration: 200
                                    easing.type: Easing.InOutQuad
                                }

                                NumberAnimation {
                                    target: topBarSelection
                                    property: "y"
                                    to: topBar.y
                                    duration: 200
                                    easing.type: Easing.InOutQuad
                                }

                                NumberAnimation {
                                    target: topBarNumber
                                    property: "y"
                                    to: topBarNumber.defaultY
                                    duration: 200
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: labContainer
        width: Math.min(parent.width, 1000)
        height: parent.height - topBar.height - 20
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }
        color: "transparent"

        StackView {
            anchors.fill: parent
            id: labStack
            initialItem: "LoaderPlug.qml"

            replaceEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 200
                }
            }

            replaceExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 200
                }
            }
        }
    }
}
