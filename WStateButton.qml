import QtQuick
import QtQuick.Effects
import QtQuick.Shapes

Item {
    id: wButton
    property alias text: wButtonText.text
    property color color: "white"
    property list<var> group
    property bool disabledCondition
    property bool pressed: false
    property bool disabled: false
    height: 40
    width: 100

    signal clicked(var mouse)
    signal released

    function release() {
        if (state === "pressed") {
            wButton.state = ""
            wButton.released()
        }
    }

    function disbale() {
        wButton.state = "disabled"
    }

    function enable() {
        wButton.state = ""
    }

    Component.onCompleted: {
        wButtonMA.clicked.connect(clicked)
    }

    Rectangle {
        id: wButtonRect
        y: 0
        color: wButton.color
        height: wButton.height
        width: wButton.width
        radius: constants.radius
        border {
            width: 1
            color: "#01bbbbff"
        }

        MouseArea {
            id: wButtonMA
            hoverEnabled: true
            anchors.fill: parent
            onClicked: {
                if (!wButton.pressed && !wButton.disabled) {
                    wButton.state = "pressed"
                    for (var i = 0; i < wButton.group.length; ++i) {
                        if (group[i] !== wButton) {
                            wButton.group[i].release()
                        }
                    }
                }
            }
        }

        Text {
            id: wButtonText
            property real defaultY: (parent.height - height) / 2
            y: defaultY
            anchors.horizontalCenter: parent.horizontalCenter
            color: constants.weakTextColor
            font {
                pixelSize: constants.fontSize
                family: constants.fontFamily
                bold: true
            }
        }

        Shape {
            id: dashedBorder
            opacity: 0
            anchors.fill: parent

            ShapePath {
                id: db
                strokeColor: constants.phantomTextColor
                strokeWidth: 2
                strokeStyle: ShapePath.DashLine
                fillColor: "transparent"
                property real w: dashedBorder.width
                property real h: dashedBorder.height
                property real r: constants.radius

                startX: r
                startY: h
                PathArc { relativeX: 0; y: 0; radiusX: db.r; radiusY: db.r }
                PathLine { x: db.w - db.r; relativeY: 0 }
                PathArc { relativeX: 0; y: db.h; radiusX: db.r; radiusY: db.r }
                PathLine { x: db.r; relativeY: 0 }
            }
        }

        Shape {
            id: thickBorder
            opacity: 0
            anchors.fill: parent

            ShapePath {
                id: tb
                strokeColor: constants.weakTextColor
                strokeWidth: 0
                fillColor: "transparent"
                property real w: dashedBorder.width
                property real h: dashedBorder.height
                property real r: constants.radius

                startX: r
                startY: h
                PathArc { relativeX: 0; y: 0; radiusX: tb.r; radiusY: tb.r }
                PathLine { x: tb.w - tb.r; relativeY: 0 }
                PathArc { relativeX: 0; y: tb.h; radiusX: tb.r; radiusY: tb.r }
                PathLine { x: tb.r; relativeY: 0 }
            }
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

    transitions: [
        Transition {
            from: "pressed"
            PropertyAnimation {
                properties: "color, color.r, color.g, color.b, shadowBlur, shadowScale, shadowVerticalOffset, shadowOpacity, strokeWidth, y, opacity"
                duration: 200
                easing.type: Easing.InOutQuad
            }
        },

        Transition {
            to: "pressed"
            PropertyAnimation {
                properties: "color, color.r, color.g, color.b, shadowBlur, shadowScale, shadowVerticalOffset, shadowOpacity, strokeWidth, y, opacity"
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    ]

    states: [
        State {
            name: ""
            PropertyChanges { target: wButtonRect; border.color: "#01bbbbff"}
        },

        State {
            name: "hovered"
            when: wButtonMA.containsMouse && !wButton.pressed && !wButton.disabled
            PropertyChanges { target: wButtonRect; border.color: "#ffbbbbff"}
        },

        State {
            name: "pressed"
            // PropertyChanges { target: wButton; pressed: true }
            PropertyChanges { target: wButtonText; color: constants.strongTextColor }
            PropertyChanges { target: wButtonRect; color.r: wButton.color.r * 0.98 }
            PropertyChanges { target: wButtonRect; color.g: wButton.color.g * 0.98 }
            PropertyChanges { target: wButtonRect; color.b: wButton.color.b * 0.98 }
            PropertyChanges { target: wButtonRect; y: 3 }
            PropertyChanges { target: wButtonShadow; shadowBlur: 0.1 }
            PropertyChanges { target: wButtonShadow; shadowScale: 0.95 }
            PropertyChanges { target: wButtonShadow; shadowVerticalOffset: 0 }
            PropertyChanges { target: wButtonShadow; shadowOpacity: 0.5 }
            PropertyChanges { target: thickBorder; opacity: 1 }
            PropertyChanges { target: tb; strokeWidth: 2 }
            PropertyChanges { target: wButtonMA; hoverEnabled: false }
        },

        State {
            name: "disabled"
            when: wButton.disabledCondition
            PropertyChanges { target: wButton; disabled: true }
            PropertyChanges { target: wButtonText; color: constants.phantomTextColor }
            PropertyChanges { target: wButtonRect; y: 0 }
            PropertyChanges { target: wButtonShadow; shadowBlur: 0 }
            PropertyChanges { target: wButtonShadow; shadowScale: 0.95 }
            PropertyChanges { target: wButtonShadow; shadowVerticalOffset: 0 }
            PropertyChanges { target: wButtonShadow; shadowOpacity: 0 }
            PropertyChanges { target: dashedBorder; opacity: 1 }
            PropertyChanges { target: wButtonMA; hoverEnabled: false }
        }
    ]
}
