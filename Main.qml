import QtQuick
import QtQuick.Effects

Window {
    visible: true
    title: qsTr("Computer Security Labs")

    Item {
        id: data
        visible: false
        property int labCount: 5
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
        shadowOpacity: 0.1
        shadowVerticalOffset: 3
    }

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
                            topBarNumber.color = "#222"
                        }
                        onExited: {
                            topBarNumber.color = topBarNumber.defaultColor
                        }
                        onClicked: {
                            data.clickedButton = this
                            topBarClickAnimation.restart()
                            labLoader.setSource("Lab" + (index + 1) + ".qml")
                        }

                        Text {
                            id: topBarNumber
                            property int defaultY: (parent.height - height) / 2
                            y: defaultY
                            anchors.horizontalCenter: parent.horizontalCenter
                            property string defaultColor: "#aaa"

                            color: defaultColor
                            font {
                                family: "monospace"
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
                                    to: 0.3
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
                                    to: 0.1
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
        width: parent.width
        height: parent.height - topBar.height - 20
        anchors.bottom: parent.bottom
        color: "transparent"

        Loader {
            anchors.fill: parent
            id: labLoader
            source: "LoaderPlug.qml"
        }
    }
}
