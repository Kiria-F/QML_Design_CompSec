import QtQuick
import QtQuick.Shapes

Item {
    id: core
    property int ruleLen: 8
    property list<int> number: [0, 0, 0, 0, 0, 0, 0, 1]
    property list<int> rule: [1, 0, 0, 0, 1, 1, 1, 0, 1]

    Item {
        id: row
        property real spacing: 50
        property real boxSize: constants.radius * 2
        property real boxRad: constants.radius / 2

        anchors.centerIn: parent
        width: core.ruleLen * (boxSize + spacing) - spacing

        Repeater {
            model: ruleLen

            Rectangle {
                id: node
                required property int index;

                x: (width + row.spacing) * node.index
                width: row.boxSize
                height: row.boxSize
                radius: row.boxRad
                border {
                    width: 2
                    color: constants.strongTextColor
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        core.number[node.index] = 1 - core.number[node.index]
                    }
                }

                WText {
                    id: nodeText

                    anchors.centerIn: parent
                    text: core.number[node.index]
                    color: constants.strongTextColor
                }
            }
        }

        Shape {
            id: bottomArrow
            y: 100

            ShapePath {
                strokeColor: constants.weakTextColor
                strokeWidth: 2
                fillColor: 'transparent'
                capStyle: ShapePath.FlatCap

                startX: row.width
                startY: -bottomArrow.y + row.boxSize / 2
                PathLine { relativeX: row.spacing / 2 - row.boxRad; relativeY: 0}
                PathArc { relativeX: row.boxRad; relativeY: row.boxRad; radiusX: row.boxRad; radiusY: row.boxRad }
                PathLine { relativeX: 0; y: -row.boxRad }
                PathArc { relativeX: -row.boxRad; relativeY: row.boxRad; radiusX: row.boxRad; radiusY: row.boxRad }
                PathLine { x: -row.spacing / 2 + row.boxRad; relativeY: 0}
                PathArc { relativeX: -row.boxRad; relativeY: -row.boxRad; radiusX: row.boxRad; radiusY: row.boxRad }
                PathLine { relativeX: 0; y: -bottomArrow.y + row.boxSize / 2 + row.boxRad }
                PathArc { relativeX: row.boxRad; relativeY: -row.boxRad; radiusX: row.boxRad; radiusY: row.boxRad }
                PathLine { x: 0; relativeY: 0 }
            }
        }

        Repeater {
            model: core.ruleLen - 1

            Item {
                id: xor
                required property int index
                property int ruleVal: core.rule[index + 1]

                states: [
                    State {
                        name: "on"
                        when: xor.ruleVal == 1
                        PropertyChanges {
                            xDAr { opacity: 1 }
                            xNodeText { opacity: 1 }
                            xNode { opacity: 1 }
                        }
                    },
                    State {
                        name: "off"
                        when: xor.ruleVal == 0
                        PropertyChanges {
                            xDAr { opacity: 0 }
                            xNodeText { opacity: 0 }
                            xNode { opacity: 0 }
                        }
                    }
                ]

                transitions: [
                    Transition {
                        PropertyAnimation {
                            properties: "opacity"
                            duration: 200
                            easing.type: Easing.InOutQuad
                        }
                    }
                ]

                Shape {
                    ShapePath {
                        strokeColor: constants.weakTextColor
                        strokeWidth: 2
                        fillColor: 'transparent'
                        capStyle: ShapePath.FlatCap

                        startX: row.boxSize + (row.spacing + row.boxSize) * xor.index
                        startY: row.boxSize / 2
                        PathLine { relativeX: row.spacing; relativeY: 0 }
                    }

                    ShapePath {
                        id: xRArTip
                        property real s: 15
                        property real h: s
                        property real w: s

                        fillColor: constants.weakTextColor

                        startX: (row.boxSize + row.spacing) * (xor.index + 1) - w
                        startY: row.boxSize / 2 + h / 2
                        PathLine { relativeX: xRArTip.w; y: row.boxSize / 2 }
                        PathLine { relativeX: - xRArTip.w; y: row.boxSize / 2 - xRArTip.h / 2 }
                        PathArc  { x: xRArTip.startX; y: xRArTip.startY; radiusX: 20; radiusY: 20 }
                    }
                }

                Shape {
                    id: xDAr

                    ShapePath {
                        strokeColor: constants.weakTextColor
                        strokeWidth: 2
                        fillColor: 'transparent'
                        capStyle: ShapePath.FlatCap

                        startX: row.boxSize + (row.spacing + row.boxSize) * xor.index
                        startY: row.boxSize / 2
                        PathLine { relativeX: row.spacing / 2 - row.boxRad; relativeY: 0 }
                        PathArc { relativeX: row.boxRad; relativeY: row.boxRad; radiusX: row.boxRad; radiusY: row.boxRad }
                        PathLine { relativeX: 0; y: bottomArrow.y - row.boxSize / 2 - 5 }
                    }

                    ShapePath {
                        id: xDArTip
                        property real s: 15
                        property real h: s
                        property real w: s

                        fillColor: constants.weakTextColor

                        startX: row.boxSize + (row.spacing + row.boxSize) * xor.index + row.spacing / 2
                        startY: bottomArrow.y - row.boxSize / 2
                        PathLine { relativeX: -xDArTip.w / 2; relativeY: -xDArTip.h }
                        PathArc  { relativeX: xDArTip.w; relativeY: 0; radiusX: xDArTip.s; radiusY: xDArTip.s; direction: PathArc.Counterclockwise }
                        PathLine { relativeX: -xDArTip.w / 2; relativeY: xDArTip.h }
                    }
                }

                Rectangle {
                    id: xNode

                    x: row.boxSize / 2 + (row.spacing + row.boxSize) * xor.index + row.spacing / 2
                    y: bottomArrow.y - row.boxSize / 2
                    width: row.boxSize
                    height: row.boxSize
                    radius: constants.radius
                    border {
                        width: 2
                        color: constants.weakTextColor
                    }

                    MouseArea {
                        id: xNodeMA
                        anchors.fill: parent
                        hoverEnabled: true

                        onClicked: core.rule[xor.index + 1] ^= 1
                        onEntered: xNodeDashedBorder.state = 'on'
                        onExited: xNodeDashedBorder.state = 'off'
                    }

                    WText {
                        id: xNodeText

                        anchors.horizontalCenter: parent.horizontalCenter
                        y: 6
                        text: '^'
                        color: constants.weakTextColor
                        font.pixelSize: constants.fontSize * 1.25
                    }
                }

                Shape {
                    id: xNodeDashedBorder
                    anchors.fill: xNode
                    state: 'off'

                    states: [
                        State {
                            name: "on"
                            PropertyChanges {
                                target: xNodeDashedBorder
                                opacity: 1
                            }
                        },
                        State {
                            name: "off"
                            PropertyChanges {
                                target: xNodeDashedBorder
                                opacity: 0
                            }
                        }
                    ]

                    transitions: [
                        Transition {
                            PropertyAnimation {
                                properties: "opacity"
                                duration: 200
                                easing.type: Easing.InOutQuad
                            }
                        }
                    ]

                    ShapePath {
                        strokeColor: constants.weakTextColor
                        strokeWidth: 2
                        strokeStyle: ShapePath.DashLine
                        dashPattern: [2, 4]
                        fillColor: "transparent"

                        startX: row.boxSize / 2
                        startY: 1
                        PathArc { relativeX: 0; y: row.boxSize - 1; radiusX: row.boxRad - 1; radiusY: row.boxRad - 1; }
                        PathArc { relativeX: 0; y: 1; radiusX: row.boxRad - 1; radiusY: row.boxRad - 1; }
                    }

                    ShapePath {
                        strokeColor: 'white'
                        strokeWidth: 2
                        strokeStyle: ShapePath.DashLine
                        dashPattern: [2, 4]
                        dashOffset: 3
                        fillColor: "transparent"

                        startX: row.boxSize / 2
                        startY: 1
                        PathArc { relativeX: 0; y: row.boxSize - 1; radiusX: row.boxRad - 1; radiusY: row.boxRad - 1; }
                        PathArc { relativeX: 0; y: 1; radiusX: row.boxRad - 1; radiusY: row.boxRad - 1; }
                    }
                }
            }
        }


        Shape {
            ShapePath {
                id: rArFirst
                property real s: 15
                property real h: s
                property real w: s

                fillColor: constants.weakTextColor

                startX: -w
                startY: row.boxSize / 2 + h / 2
                PathLine { relativeX: rArFirst.w; y: row.boxSize / 2 }
                PathLine { relativeX: - rArFirst.w; y: row.boxSize / 2 - rArFirst.h / 2 }
                PathArc  { x: rArFirst.startX; y: rArFirst.startY; radiusX: 20; radiusY: 20 }
            }
        }
    }
}
