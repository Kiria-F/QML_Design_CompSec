import QtQuick
import QtQuick.Effects

Window {
    visible: true
    title: qsTr("Computer Security Labs")

    Item {
        id: data
        visible: false
        property int labCount: 5
    }

    MultiEffect {
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
        property int numSize: 20
        height: childrenRect.height
        width: childrenRect.width + numSpace * 3
        color: "transparent"
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 10
        }

        MouseArea {
            hoverEnabled: true
            width: childrenRect.width
            height: childrenRect.height
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
                        height: childrenRect.height + topBar.numSpace
                        width: childrenRect.width + topBar.numSpace
                        property bool hovered: false
                        onEntered: {
                            topBarSelection.width = topBarSelection.height
                            topBarSelection.x = topBarRowMA.mapToGlobal(0, 0).x + width / 2 - topBarSelection.height / 2
                            topBarNumber.color = "#222"
                        }
                        onExited: {
                            topBarNumber.color = topBarNumber.defaultColor
                        }

                        Text {
                            id: topBarNumber
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                verticalCenter: parent.verticalCenter
                            }
                            property string defaultColor: "#aaa"

                            color: defaultColor
                            font {
                                family: "monospace"
                                bold: true
                                pixelSize: topBar.numSize
                            }
                            text: index + 1
                        }
                    }
                }
            }
        }

        Rectangle {
            id: mainContainer

            property list<QtObject> labs: [Lab1, Lab2]
        }
    }
}
