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
            leftMargin: 40
            verticalCenter: parent.verticalCenter
        }
        border {
            width: 1
            color: "black"
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

    TextArea {
        id: hashArea
        anchors {
            right: parent.right
            rightMargin: 40
            verticalCenter: parent.verticalCenter
        }
        font {
            family: "monospace"
            bold: true
            pixelSize: 20
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
                }
            }
        }

        Row {

        }
    }
}
