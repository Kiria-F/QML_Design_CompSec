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
                required property int index;

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
                        id: rAr
                        property real s: 15
                        property real h: s
                        property real w: s

                        fillColor: constants.weakTextColor

                        startX: (row.boxSize + row.spacing) * (xor.index + 1) - w
                        startY: row.boxSize / 2 + h / 2
                        PathLine { relativeX: rAr.w; y: row.boxSize / 2 }
                        PathLine { relativeX: - rAr.w; y: row.boxSize / 2 - rAr.h / 2 }
                        PathArc  { x: rAr.startX; y: rAr.startY; radiusX: 20; radiusY: 20 }
                    }

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
                        id: dAr
                        property real s: 15
                        property real h: s
                        property real w: s

                        fillColor: constants.weakTextColor

                        startX: row.boxSize + (row.spacing + row.boxSize) * xor.index + row.spacing / 2
                        startY: bottomArrow.y - row.boxSize / 2
                        PathLine { relativeX: -dAr.w / 2; relativeY: -dAr.h }
                        PathArc  { relativeX: dAr.w; relativeY: 0; radiusX: dAr.s; radiusY: dAr.s; direction: PathArc.Counterclockwise }
                        PathLine { relativeX: -dAr.w / 2; relativeY: dAr.h }
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
                        anchors.fill: parent
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
