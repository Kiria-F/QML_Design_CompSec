import QtQuick
import QtQuick.Controls.Basic

Item {
    id: wTextField
    property string placeholder
    property alias text: wTextFieldText.text
    property alias cursorPosition: wTextFieldText.cursorPosition
    property int maxTotalLength: -1
    property real lines: 1
    property bool linesAuto: false
    property real lineWidth: 10
    property bool strictLineWidth: false
    property bool hexFilter: false
    property bool numFilter: false
    property bool forceUpper: false
    property alias horizontalAlignment: wTextFieldText.horizontalAlignment
    property bool readonly: false
    height: lines * 26 + 14
    width: lineWidth * 12 + 20

    // function changeLines(newLines: real) {
    //     heightAnimation.targetHeight = newLines * 26 + 14
    //     heightAnimation.restart()
    // }

    Component.onCompleted: {
        wTextFieldText.textChanged.connect(textChanged)
        height = lines * 26 + 14
    }

    onLinesChanged: {
        heightAnimation.targetLines = lines
        heightAnimation.restart()
    }

    onWidthChanged: {
        lineWidth = (width - 20) / 12
    }

    // transitions: [
    //     Transition {
    //         PropertyAnimation {
    //             properties: 'height'
    //             duration: 400
    //             easing.type: Easing.InOutQuad
    //         }
    //     }
    // ]

    PropertyAnimation {
        id: heightAnimation
        property real targetLines
        target: wTextField
        property: "height"
        to: targetLines * 26 + 14
        duration: 400
        easing.type: Easing.InOutQuad
    }

    Rectangle {
        id: wTextFieldBorder
        anchors.fill: parent
        radius: constants.radius
        border {
            width: 2
            color: wTextField.readonly ? constants.weakTextColor : constants.strongTextColor
        }
        clip: true

        TextEdit {
            id: wTextFieldText
            readOnly: wTextField.readonly
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
                pixelSize: constants.fontSize
            }
            selectionColor: constants.strongTextColor

            function setTextWidth() {
                let lineWidth = Math.round(wTextField.lineWidth)
                let lineIndex = 0
                for (let i = 0; i < text.length; ++i) {
                    if (text[i] === '\n') {
                        if (lineIndex === lineWidth && i !== text.length - 1) {
                            lineIndex = 0
                            continue
                        }
                        if (wTextField.strictLineWidth) {
                            text = text.slice(0, i) + text.slice(i + 1)
                            --i
                        } else {
                            lineIndex = 0
                        }
                        continue
                    }
                    if (lineIndex === lineWidth) {
                        text = text.slice(0, i) + '\n' + text.slice(i)
                        ++i
                        lineIndex = 0
                    }
                    ++lineIndex
                }
            }

            function filter(rule: string) {
                rule += '\n'
                for (let i = 0; i < text.length; ++i) {
                    if (rule.indexOf(text[i]) === -1) {
                        text = text.slice(0, i) + text.slice(i + 1)
                        --i
                    }
                }
            }

            function limitTotalLength() {
                let maxLen = wTextField.maxTotalLength
                if (strictLineWidth) {
                    maxLen += wTextField.lines - 1
                }
                text = text.substring(0, maxLen)
            }

            onTextChanged: {
                let pos = cursorPosition
                let rawTextLen = text.length;
                if (wTextField.forceUpper) text = text.toUpperCase()
                if (wTextField.hexFilter) filter('0123456789abcdefABCDEF')
                if (wTextField.numFilter) filter('0123456789')
                setTextWidth(wTextField.lineWidth)
                if (wTextField.maxTotalLength >= 0) limitTotalLength()
                if (wTextField.linesAuto) wTextField.lines = text.split('\n').length
                cursorPosition = pos - (rawTextLen - text.length)
            }

            PlaceholderText {
                id: wTextFieldPlaceholder
                anchors.centerIn: parent
                text: wTextFieldText.text.length === 0 ? wTextField.placeholder : ""
                color: constants.weakTextColor
                font {
                    family: constants.fontFamily
                    bold: true
                    pixelSize: constants.fontSize
                }
            }
        }
    }
}
