import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import QtQuick.Controls
import "."

Item {
    id: lab1
    property int selectedMode: 0

    Rectangle {
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
            id: keyField
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
                family: "monospace"
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
                text: keyField.text.length === 0 ? "0000000" : ""
                color: constants.weakTextColor
                font {
                    family: "monospace"
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
                    duration: 200
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
                family: "monospace"
                bold: true
                pixelSize: 20
            }
            text: "0000000000000000\n0000000000000000\n0000000000000000\n0000000000000000\n0000000000000000\n0000000000000000\n0000000000000000\n0000000000000000"
        }
    }

    Column {
        spacing: 10
        anchors.centerIn: parent

        Row {
            spacing: 10

            WStateButton {
                id: btnMD5
                text: "MD5"
                onClicked: {
                    btnSHA1.release()
                    btnSHA256.release()
                    btnSHA512.release()
                    lab1.selectedMode = 0
                    hashField.state = "MD5"
                }
            }

            WStateButton {
                id: btnSHA1
                text: "SHA1"
                onClicked: {
                    btnMD5.release()
                    btnSHA256.release()
                    btnSHA512.release()
                    lab1.selectedMode = 1
                    hashField.state = "SHA1"
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
                    lab1.selectedMode = 2
                    hashField.state = "SHA256"
                }
            }

            WStateButton {
                id: btnSHA512
                text: "SHA512"
                onClicked: {
                    btnMD5.release()
                    btnSHA1.release()
                    btnSHA256.release()
                    lab1.selectedMode = 3
                    hashField.state = "SHA512"
                }
            }
        }

        Row {

        }
    }
}
