import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import QtQuick.Controls
import "."

Item {
    id: lab1

    Rectangle {
        id: keyField
        height: 40
        width: 100
        radius: height / 2
        anchors {
            left: parent.left
            leftMargin: 100
            verticalCenter: parent.verticalCenter
        }
        border {
            width: 2
            color: constants.strongTextColor
        }

        TextEdit {
            id: keyFieldText
            anchors {
                fill: parent
                topMargin: 6
                bottomMargin: 6
                leftMargin: 8
                rightMargin: 8
            }
            horizontalAlignment: TextEdit.AlignHCenter
            color: constants.strongTextColor
            font {
                family: constants.fontFamily
                bold: true
                pixelSize: 20
            }
            onTextChanged: {
                let pos = cursorPosition
                let aLen = text.length;
                text = labCore1.validateKey(text);
                cursorPosition = pos - (aLen - text.length)
            }

            PlaceholderText {
                text: keyFieldText.text.length === 0 ? "0000000" : ""
                color: constants.weakTextColor
                font {
                    family: constants.fontFamily
                    bold: true
                    pixelSize: 20
                }
            }
        }
    }

    Rectangle {
        id: hashField
        property real linesCount: 2
        width: 7 * 16 - 2 + anchors.leftMargin + anchors.rightMargin
        height: 28 * linesCount + 9 + anchors.topMargin + anchors.bottomMargin
        radius: 20
        anchors {
            right: parent.right
            rightMargin: 100
            verticalCenter: parent.verticalCenter
        }
        border {
            width: 2
            color: constants.strongTextColor
        }

        states: [
            State {
                name: "MD5"
                PropertyChanges {
                    target: hashField
                    linesCount: 2
                }
            },
            State {
                name: "SHA1"
                PropertyChanges {
                    target: hashField
                    linesCount: 3
                }
            },
            State {
                name: "SHA256"
                PropertyChanges {
                    target: hashField
                    linesCount: 4
                }
            },
            State {
                name: "SHA512"
                PropertyChanges {
                    target: hashField
                    linesCount: 8
                }
            }
        ]

        transitions: [
            Transition {
                NumberAnimation {
                    property: "linesCount"
                    easing.type: Easing.InOutQuad
                    duration: 400
                }
            }
        ]

        TextEdit {
            id: hashFieldText
            anchors {
                fill: parent
                topMargin: 6
                bottomMargin: 6
                leftMargin: 8
                rightMargin: 8
            }
            color: constants.strongTextColor
            font {
                family: "JetBrainsMono Nerd Font"
                bold: true
                pixelSize: 20
            }
            inputMethodHints: Qt.ImhNone
            onTextChanged: {
                let pos = cursorPosition
                let aLen = text.length;
                text = labCore1.validateHash(hashField.state, text);
                cursorPosition = pos - (aLen - text.length)
            }
        }
    }

    Column {
        id: buttonsContainer
        spacing: 10
        anchors.centerIn: parent

        function commonHandler() {
            hashFieldText.text = labCore1.validateHash(hashField.state, hashFieldText.text);
        }

        Row {
            spacing: 10

            WStateButton {
                id: btnMD5
                text: "MD5"
                onClicked: {
                    btnSHA1.release()
                    btnSHA256.release()
                    btnSHA512.release()
                    hashField.state = "MD5"
                    buttonsContainer.commonHandler()
                }
            }

            WStateButton {
                id: btnSHA1
                text: "SHA1"
                onClicked: {
                    btnMD5.release()
                    btnSHA256.release()
                    btnSHA512.release()
                    hashField.state = "SHA1"
                    buttonsContainer.commonHandler()
                }
            }
        }

        Row {
            spacing: 10

            WStateButton {
                id: btnSHA256
                text: "SHA256"
                onClicked: {
                    btnMD5.release()
                    btnSHA1.release()
                    btnSHA512.release()
                    hashField.state = "SHA256"
                    buttonsContainer.commonHandler()
                }
            }

            WStateButton {
                id: btnSHA512
                text: "SHA512"
                onClicked: {
                    btnMD5.release()
                    btnSHA1.release()
                    btnSHA256.release()
                    hashField.state = "SHA512"
                    buttonsContainer.commonHandler()
                }
            }
        }
    }

    Shape {
        id: ars
        opacity: 0.075
        anchors.fill: parent
        antialiasing: true
        property real w: keyField.width
        property real r: 10
        property real br: 20
        property real space: 10
        property real tipW: 200
        property real tipH: 100
        property real preTip: 40
        property real lc: keyField.x + keyField.width / 2
        property real ll: lc - w / 2
        property real lr: ll + w
        property real rc: hashField.x + hashField.width / 2
        property real rl: rc - w / 2
        property real rr: rl + w

        ShapePath {
            id: tar
            fillColor: "black"
            property real b: hashField.y - ars.space - ars.tipH - ars.preTip;
            property real t: b - ars.w
            property real lb: keyField.y - ars.space
            property real rb: hashField.y - ars.space
            property real tipY: rb - ars.tipH;

            startX: ars.ll + ars.br
            startY: lb
            PathArc { relativeX: -ars.br; relativeY: -ars.br; radiusX: ars.br; radiusY: ars.br }
            PathLine { relativeX: 0; y: tar.t + ars.r }
            PathArc { relativeX: ars.br; relativeY: -ars.br; radiusX: ars.br; radiusY: ars.br }
            PathLine { x: ars.rr - ars.br; relativeY: 0 }
            PathArc { relativeX: ars.br; relativeY: ars.br; radiusX: ars.br; radiusY: ars.br }
            PathLine { relativeX: 0; y: tar.tipY - ars.r }
            PathArc { relativeX: ars.r; relativeY: ars.r; radiusX: ars.r; radiusY: ars.r; direction: PathArc.Counterclockwise }
            property var t1: geometry.arcConnect(ars.r, ars.rc, tar.tipY, ars.rc + ars.tipW / 2, tar.tipY, ars.rc, tar.rb)
            PathLine { x: tar.t1.lx; y: tar.t1.ly }
            PathArc { x: tar.t1.ax; y: tar.t1.ay; radiusX: ars.r; radiusY: ars.r; }
            property var t2: geometry.arcConnect(ars.r, ars.rc + ars.tipW / 2, tar.tipY, ars.rc, tar.rb, ars.rc - ars.tipW / 2, tar.tipY)
            PathLine { x: tar.t2.lx; y: tar.t2.ly }
            PathArc { x: tar.t2.ax; y: tar.t2.ay; radiusX: ars.r; radiusY: ars.r; }
            property var t3: geometry.arcConnect(ars.r, ars.rc, tar.rb, ars.rc - ars.tipW / 2, tar.tipY, ars.rc, tar.tipY)
            PathLine { x: tar.t3.lx; y: tar.t3.ly }
            PathArc { x: tar.t3.ax; y: tar.t3.ay; radiusX: ars.r; radiusY: ars.r; }
            PathLine { x: ars.rl - ars.r; relativeY: 0 }
            PathArc { relativeX: ars.r; relativeY: -ars.r; radiusX: ars.r; radiusY: ars.r; direction: PathArc.Counterclockwise }
            PathLine { relativeX: 0; y: tar.b + ars.r}
            PathArc { relativeX: -ars.r; relativeY: -ars.r; radiusX: ars.r; radiusY: ars.r; direction: PathArc.Counterclockwise }
            PathLine { x: ars.lr + ars.r; relativeY: 0 }
            PathArc { relativeX: -ars.r; relativeY: ars.r; radiusX: ars.r; radiusY: ars.r; direction: PathArc.Counterclockwise }
            PathLine { relativeX: 0; y: tar.lb - ars.br }
            PathArc { relativeX: -ars.br; relativeY: ars.br; radiusX: ars.br; radiusY: ars.br; }


            // PathLine { relativeX: 0; y: tar.b + ars.r }
            // PathArc { relativeX: -ars.r; relativeY: -ars.r; radiusX: ars.r; radiusY: ars.r; direction: PathArc.Counterclockwise }
            // PathLine { x: ars.lr + ars.r; relativeY: 0 }
            // PathArc { relativeX: -ars.r; relativeY: ars.r; radiusX: ars.r; radiusY: ars.r; direction: PathArc.Counterclockwise }
            // PathLine { relativeX: 0; y: tar.lb - ars.r }
            // PathArc { relativeX: -ars.r; relativeY: ars.r; radiusX: ars.r; radiusY: ars.r }
        }
    }
    Shape {
        id: debugDot
        visible: false
        property real cx: ars.rc
        property real cy: tar.tipY
        property real r: 6
        antialiasing: true
        ShapePath {
            fillColor: "red"
            startX: debugDot.cx - debugDot.r
            startY: debugDot.cy
            PathArc { relativeX: 2 * debugDot.r; relativeY: 0; radiusX: debugDot.r; radiusY: debugDot.r }
            PathArc { relativeX: -2 * debugDot.r; relativeY: 0; radiusX: debugDot.r; radiusY: debugDot.r }
        }
    }
}
