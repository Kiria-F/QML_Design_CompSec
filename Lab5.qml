import QtQuick
import QtQuick.Shapes

Item {
    id: core
    property list<int> number: [0, 0, 0, 0, 0, 0, 0, 1]
    property list<int> rule: [1, 0, 0, 0, 1, 1, 1, 0, 1]
    property int ruleLen: rule.length
    property int bitsCount: ruleLen - 1
    property bool componenetCompleted: false

    Component.onCompleted: componenetCompleted = true

    function render(bitsSource) {
        let bits = bitsSource === 'rule' ? rule : number

        let acc = 0
        for (let i = 0; i < bits.length; ++i) {
            if (bits[i]) {
                acc += 1 << (bits.length - 1 - i)
            }
        }
        return acc
    }

    onRuleChanged: {
        if (componenetCompleted) {
            let context2d = canvas.getContext('2d')
            context2d.fillStyle = Qt.rgba(1, 1, 1, 1)
            context2d.fillRect(0, 0, canvas.width, canvas.height);
            labCore5.updateRule(render('rule'));
            canvas.requestPaint()
        }
    }

    Connections {
        target: labCore5

        function onAddPoint(x, y) {
            let context2d = canvas.getContext('2d')
            context2d.fillStyle = Qt.rgba(0, 0, 0, 0.2)
            context2d.fillRect(x, y, 2, 2);
            canvas.requestPaint()
        }
    }

    Column {
        anchors.centerIn: parent
        width: row.width
        spacing: 40

        Row {
            id: formula
            property real fHeight: 30
            height: childrenRect.height
            anchors.horizontalCenter: parent.horizontalCenter

            Item {
                height: formula.fHeight
                width: children[0].width

                WText {
                    anchors.bottom: parent.bottom
                    text: 'p(X)'
                }
            }

            Item {
                height: formula.fHeight
                width: children[0].width + 15

                WText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    text: '='
                }
            }

            Repeater {
                model: ruleLen

                Item {
                    required property int index
                    property int powerVal: (ruleLen - 1) - index
                    width: childrenRect.width
                    height: childrenRect.height
                    visible: core.rule[index] === 1

                    Item {
                        visible: powerVal > 0
                        width: children[0].width

                        Row {
                            Item {
                                height: formula.fHeight
                                width: children[0].width

                                WText {
                                    anchors.bottom: parent.bottom
                                    text: 'X'
                                }
                            }

                            Item {
                                height: formula.fHeight
                                width: children[0].width

                                WText {
                                    anchors.top: parent.top
                                    text: powerVal
                                    font.pixelSize: constants.fontSize * 0.75
                                }
                            }

                            Item {
                                height: formula.fHeight
                                width: children[0].width + 15

                                WText {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.bottom: parent.bottom
                                    text: '+'
                                }
                            }
                        }
                    }

                    Item {
                        height: formula.fHeight
                        width: children[0].width
                        visible: powerVal == 0

                        WText {
                            anchors.bottom: parent.bottom
                            text: '1'
                        }
                    }
                }
            }
        }


        Item {
            id: row
            property real spacing: 50
            property real boxSize: constants.radius * 2
            property real boxRad: constants.radius / 2

            width: core.bitsCount * (boxSize + spacing) - spacing
            height: childrenRect.height

            Repeater {
                model: core.bitsCount

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
                model: core.bitsCount - 1

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

        WButton {
            anchors.horizontalCenter: parent.horizontalCenter
            color: '#aaffaa'
            text: 'Next'

            Component.onCompleted: width *= 1.5

            onClicked: {
                let newNum = labCore5.generate(core.render('rule'), core.render('num'))
                for (let i = 0; i < core.bitsCount; ++i) {
                    core.number[i] = newNum >> (core.bitsCount - 1 - i) & 1
                }
            }
        }

        WText {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: constants.fontSize * 2
            text: core.render('num')
        }

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: canvas.width + 4
            height: canvas.width + 4
            border {
                width: 2
                color: constants.weakTextColor
            }

            Canvas {
                id: canvas
                anchors.centerIn: parent
                renderStrategy: Canvas.Threaded
                width: 256
                height: 256
            }
        }
    }
}
