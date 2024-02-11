import QtQuick
import QtQuick.Controls.Basic

Item {
    id: wTextField
    property string placeholder
    property alias text: wTextFieldText.text
    property alias cursorPosition: wTextFieldText.cursorPosition
    property real lines: 1
    property real length: 10
    property alias horizontalAlignment: wTextFieldText.horizontalAlignment
    height: lines * 26 + 14
    width: length * 12 + 20

    Component.onCompleted: {
        wTextFieldText.textChanged.connect(textChanged)
    }

    Rectangle {
        id: wTextFieldBorder
        anchors.fill: parent
        radius: constants.radius
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
                leftMargin: 10
                rightMargin: 10
            }
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
