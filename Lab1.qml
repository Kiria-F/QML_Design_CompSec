import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import QtQuick.Controls
import QtCharts

Item {
    id: core
    property list<var> seriesOrder: [md5Series, sha1Series, sha256Series, sha512Series]

    Connections {
        target: labCore1

        function onProgressChanged(progress) {
            progressBar.progress = progress
        }

        function onKeyFound(key, ms) {
            progressBar.progress = 0
            keyField.text = key
            if (ms >= 0) {
                timeText.text = ms + " ms"
            } else {
                timeText.text = "Not Found"
            }
        }

        function onGraphCalced(mode: string, mss: list<int>) {
            var curIndex = 0
            for (var i = 0; i < core.seriesOrder.length; ++i)
                if (core.seriesOrder[i].name === mode)
                    curIndex = i

            for (i = 1; i < mss.length; ++i) {
                core.seriesOrder[curIndex].append(i, mss[i])
            }
            seriesOrder[curIndex].axisY.max = Math.max(seriesOrder[curIndex].axisY.max, mss[mss.length - 1])

            if (curIndex < core.seriesOrder.length - 1) {
                labCore1.calcGraph(seriesOrder[curIndex + 1].name)
            }
        }
    }

    WTextField {
        id: keyField
        lines: 1
        length: 7
        x: 150 - width / 2
        anchors.verticalCenter: parent.verticalCenter
        placeholder: "0000000"
        horizontalAlignment: TextEdit.AlignHCenter
        onTextChanged: {
            let pos = cursorPosition
            let aLen = text.length;
            text = labCore1.validateKey(text);
            cursorPosition = pos - (aLen - text.length)
        }
    }

    WTextField {
        id: hashField
        lines: 2
        length: 16
        x: parent.width - 150 - width / 2
        anchors.verticalCenter: parent.verticalCenter
        states: [
            State {
                name: "MD5"
                PropertyChanges {
                    target: hashField
                    lines: 2
                }
            },
            State {
                name: "SHA1"
                PropertyChanges {
                    target: hashField
                    lines: 3
                }
            },
            State {
                name: "SHA256"
                PropertyChanges {
                    target: hashField
                    lines: 4
                }
            },
            State {
                name: "SHA512"
                PropertyChanges {
                    target: hashField
                    lines: 8
                }
            }
        ]

        transitions: [
            Transition {
                NumberAnimation {
                    property: "lines"
                    easing.type: Easing.InOutQuad
                    duration: 400
                }
            }
        ]

        onTextChanged: {
            let pos = cursorPosition
            let aLen = text.length;
            text = labCore1.validateHash(hashField.state, text);
            cursorPosition = pos - (aLen - text.length)
        }
    }

    Column {
        id: buttonsContainer
        spacing: 10
        anchors.centerIn: parent
        property list<var> btnGroup: [btnMD5, btnSHA1, btnSHA256, btnSHA512]

        function commonHandler() {
            hashField.text = labCore1.validateHash(hashField.state, hashField.text);
        }

        Row {
            spacing: 10

            WStateButton {
                id: btnMD5
                text: "MD5"
                group: buttonsContainer.btnGroup

                onClicked: {
                    hashField.state = "MD5"
                    buttonsContainer.commonHandler()
                }
            }

            WStateButton {
                id: btnSHA1
                text: "SHA1"
                group: buttonsContainer.btnGroup

                onClicked: {
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
                group: buttonsContainer.btnGroup

                onClicked: {
                    hashField.state = "SHA256"
                    buttonsContainer.commonHandler()
                }
            }

            WStateButton {
                id: btnSHA512
                text: "SHA512"
                group: buttonsContainer.btnGroup

                onClicked: {
                    hashField.state = "SHA512"
                    buttonsContainer.commonHandler()
                }
            }
        }
    }

    WButton {
        id: graphBtn
        anchors.horizontalCenter: parent.horizontalCenter
        y: bar.i - height - 20
        text: "Graph"

        onClicked: {
            graphPopUp.show()
            labCore1.calcGraph(core.seriesOrder[0].name)
        }
    }

    WPopUp {
        id: graphPopUp
        anchors.centerIn: parent
        width: 600
        height: 600
        autohide: false

        ChartView {
            title: "Restoration time"
            anchors.fill: parent
            antialiasing: true

            MouseArea
            {
                id: chartMouseArea
                anchors.fill: parent
                // propagateComposedEvents: true

                onClicked:
                {
                    graphPopUp.hide()
                    for (var i = 0; i < core.seriesOrder.length; ++i) {
                        core.seriesOrder[i].clear()
                        core.seriesOrder[i].axisY.max = 10
                    }
                }
            }

            LineSeries {
                id: md5Series
                name: "MD5"
                axisX: ValuesAxis {
                    max: 10
                }
                axisY: ValuesAxis {
                    max: 10
                }
            }

            LineSeries {
                id: sha1Series
                name: "SHA1"
            }

            LineSeries {
                id: sha256Series
                name: "SHA256"
            }

            LineSeries {
                id: sha512Series
                name: "SHA512"
            }
        }
    }

    WButton {
        id: hashBtn
        anchors.horizontalCenter: parent.horizontalCenter
        y: tar.o + ars.w / 2 - 10
        z: 1
        text: "Hash"

        onClicked: {
            if (keyField.text.length === 0) {
                popUp.show("You should enter\na key first")
            } else if (hashField.state === "") {
                popUp.show("Choose a hash method")
            } else {
                hashField.text = labCore1.hash(hashField.state, keyField.text)
            }
        }
    }

    WButton {
        id: restoreBtn
        anchors.horizontalCenter: parent.horizontalCenter
        y: bar.i + ars.w / 2 - 10
        z: 1
        text: "Restore"

        onClicked: {
            if (hashField.text.length === 0) {
                popUp.show("You should enter\na hash first")
            } else if (hashField.state === "") {
                popUp.show("Choose a hash method")
            } else {
                labCore1.restore(hashField.state, hashField.text)
            }
        }
    }

    Rectangle {
        id: progressBarBorder
        z: 2
        anchors {
            horizontalCenter: restoreBtn.horizontalCenter
            top: restoreBtn.bottom
            topMargin: 10
        }
        width: 300
        height: 6
        radius: 3
        border {
            color: constants.weakTextColor
            width: 1
        }

        Rectangle {
            id: progressBar
            property real progress: 0
            z: 1
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
            height: parent.height
            width: parent.width * progress
            radius: height / 2
            color: "#bbbbff"
        }
    }

    TextEdit {
        id: timeText
        anchors.horizontalCenter: parent.horizontalCenter
        y: (parent.height + bar.o) / 2 - contentHeight / 2
        color: constants.strongTextColor
        font {
            family: constants.fontFamily
            pixelSize: constants.fontSize
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
        property real lc: keyField.x + keyField.width / 2  // left part center x
        property real ll: lc - w / 2  // left part left x
        property real lr: ll + w  // left part right x
        property real rc: hashField.x + hashField.width / 2  // right part center x
        property real rl: rc - w / 2  // right part left x
        property real rr: rl + w  // right part right x

        ShapePath {
            id: tar
            fillColor: "black"
            property real i: hashField.y - ars.space - ars.tipH - ars.preTip;  // inner side y
            property real o: i - ars.w  // outer side y
            property real by: keyField.y - ars.space  // begin inner corner y
            property real ey: hashField.y - ars.space  // end inner corner y
            property real tipY: ey - ars.tipH;

            startX: ars.ll + ars.br
            startY: by
            PathArc { relativeX: -ars.br; relativeY: -ars.br; radiusX: ars.br; radiusY: ars.br }
            PathLine { relativeX: 0; y: tar.o + ars.br }
            PathArc { relativeX: ars.br; relativeY: -ars.br; radiusX: ars.br; radiusY: ars.br }
            PathLine { x: ars.rr - ars.br; relativeY: 0 }
            PathArc { relativeX: ars.br; relativeY: ars.br; radiusX: ars.br; radiusY: ars.br }
            PathLine { relativeX: 0; y: tar.tipY - ars.r }
            PathArc { relativeX: ars.r; relativeY: ars.r; radiusX: ars.r; radiusY: ars.r; direction: PathArc.Counterclockwise }
            property var t1: geometry.arcConnect(ars.r, ars.rc, tar.tipY, ars.rc + ars.tipW / 2, tar.tipY, ars.rc, tar.ey)
            PathLine { x: tar.t1.lx; y: tar.t1.ly }
            PathArc { x: tar.t1.ax; y: tar.t1.ay; radiusX: ars.r; radiusY: ars.r; }
            property var t2: geometry.arcConnect(ars.r, ars.rc + ars.tipW / 2, tar.tipY, ars.rc, tar.ey, ars.rc - ars.tipW / 2, tar.tipY)
            PathLine { x: tar.t2.lx; y: tar.t2.ly }
            PathArc { x: tar.t2.ax; y: tar.t2.ay; radiusX: ars.r; radiusY: ars.r; }
            property var t3: geometry.arcConnect(ars.r, ars.rc, tar.ey, ars.rc - ars.tipW / 2, tar.tipY, ars.rc, tar.tipY)
            PathLine { x: tar.t3.lx; y: tar.t3.ly }
            PathArc { x: tar.t3.ax; y: tar.t3.ay; radiusX: ars.r; radiusY: ars.r; }
            PathLine { x: ars.rl - ars.r; relativeY: 0 }
            PathArc { relativeX: ars.r; relativeY: -ars.r; radiusX: ars.r; radiusY: ars.r; direction: PathArc.Counterclockwise }
            PathLine { relativeX: 0; y: tar.b + ars.r}
            PathArc { relativeX: -ars.r; relativeY: -ars.r; radiusX: ars.r; radiusY: ars.r; direction: PathArc.Counterclockwise }
            PathLine { x: ars.lr + ars.r; relativeY: 0 }
            PathArc { relativeX: -ars.r; relativeY: ars.r; radiusX: ars.r; radiusY: ars.r; direction: PathArc.Counterclockwise }
            PathLine { relativeX: 0; y: tar.by - ars.br }
            PathArc { relativeX: -ars.br; relativeY: ars.br; radiusX: ars.br; radiusY: ars.br; }
        }

        ShapePath {
            id: bar
            fillColor: "black"
            property real i: hashField.y + hashField.height + ars.space + ars.tipH + ars.preTip;  // inner side y
            property real o: i + ars.w  // outer side y
            property real by: hashField.y + hashField.height + ars.space  // begin inner corner y
            property real ey: keyField.y + keyField.height + ars.space  // end inner corner y
            property real tipY: ey + ars.tipH;

            startX: ars.rr - ars.br
            startY: by
            PathArc { relativeX: ars.br; relativeY: ars.br; radiusX: ars.br; radiusY: ars.br }
            PathLine { relativeX: 0; y: bar.o - ars.r }
            PathArc { relativeX: -ars.br; relativeY: ars.br; radiusX: ars.br; radiusY: ars.br }
            PathLine { x: ars.ll + ars.br; relativeY: 0 }
            PathArc { relativeX: -ars.br; relativeY: -ars.br; radiusX: ars.br; radiusY: ars.br }
            PathLine { relativeX: 0; y: bar.tipY + ars.r }
            PathArc { relativeX: -ars.r; relativeY: -ars.r; radiusX: ars.r; radiusY: ars.r; direction: PathArc.Counterclockwise }
            property var t1: geometry.arcConnect(ars.r, ars.lc, bar.tipY, ars.lc - ars.tipW / 2, bar.tipY, ars.lc, bar.ey)
            PathLine { x: bar.t1.lx; y: bar.t1.ly }
            PathArc { x: bar.t1.ax; y: bar.t1.ay; radiusX: ars.r; radiusY: ars.r; }
            property var t2: geometry.arcConnect(ars.r, ars.lc - ars.tipW / 2, bar.tipY, ars.lc, bar.ey, ars.lc + ars.tipW / 2, bar.tipY)
            PathLine { x: bar.t2.lx; y: bar.t2.ly }
            PathArc { x: bar.t2.ax; y: bar.t2.ay; radiusX: ars.r; radiusY: ars.r; }
            property var t3: geometry.arcConnect(ars.r, ars.lc, bar.ey, ars.lc + ars.tipW / 2, bar.tipY, ars.lc, bar.tipY)
            PathLine { x: bar.t3.lx; y: bar.t3.ly }
            PathArc { x: bar.t3.ax; y: bar.t3.ay; radiusX: ars.r; radiusY: ars.r; }
            PathLine { x: ars.lr + ars.r; relativeY: 0 }
            PathArc { relativeX: -ars.r; relativeY: ars.r; radiusX: ars.r; radiusY: ars.r; direction: PathArc.Counterclockwise }
            PathLine { relativeX: 0; y: bar.i - ars.r}
            PathArc { relativeX: ars.r; relativeY: ars.r; radiusX: ars.r; radiusY: ars.r; direction: PathArc.Counterclockwise }
            PathLine { x: ars.rl - ars.r; relativeY: 0 }
            PathArc { relativeX: ars.r; relativeY: -ars.r; radiusX: ars.r; radiusY: ars.r; direction: PathArc.Counterclockwise }
            PathLine { relativeX: 0; y: bar.by + ars.br }
            PathArc { relativeX: ars.br; relativeY: -ars.br; radiusX: ars.br; radiusY: ars.br; }
        }
    }

    WPopUp {
        id: popUp
        anchors.centerIn: parent
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
