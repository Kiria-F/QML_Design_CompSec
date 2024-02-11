import QtQuick
import QtQuick.Controls.Basic

Item {
    id: wTextField
    property string placeholder
    property alias text: wTextFieldText.text
    property alias cursorPosition: wTextFieldText.cursorPosition
    property int lines: 1
    property int length: 10
    property alias horizontalAlignment: wTextFieldText.horizontalAlignment
    height: lines * 40
    width: length * 12 + 20

    Component.onCompleted: {
        wTextFieldText.textChanged.connect(textChanged)
    }

    Rectangle {
        id: wTextFieldBorder
        anchors.fill: parent
        radius: height / 2
        border {
            width: 2
            color: constants.strongTextColor
        }

        TextEdit {
            id: wTextFieldText
            anchors {
                fill: parent
                topMargin: 7
                bottomMargin: 7
            }
            horizontalAlignment: TextEdit.AlignHCenter
            color: constants.strongTextColor
            font {
                family: constants.fontFamily
                bold: true
                pixelSize: 20
            }

            PlaceholderText {
                id: wTextFieldPlaceholder
                anchors.centerIn: parent
                text: wTextFieldText.text.length === 0 ? wTextField.placeholder : ""
                color: constants.weakTextColor
                font {
                    family: constants.fontFamily
                    bold: true
                    pixelSize: 20
                }
            }
        }
    }
}
