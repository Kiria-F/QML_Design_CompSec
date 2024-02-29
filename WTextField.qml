import QtQuick
import QtQuick.Controls.Basic

Item {
    id: wTextField
    property string placeholder
    property alias text: wTextFieldText.text
    property alias cursorPosition: wTextFieldText.cursorPosition
    property int maxTotalLength: -1
    property real lines: 1
    property int maxLines: lines
    property bool linesAuto: false
    property real lineWidth: 10
    property bool strictLineWidth: false
    property bool hexFilter: false
    property bool numFilter: false
    property bool forceUpper: false
    property alias horizontalAlignment: wTextFieldText.horizontalAlignment
    property bool readonly: false
    property bool lineWidthAuto: true
    height: lines * 26 + 14
    width: lineWidth * 12 + 20

    Component.onCompleted: {
        height = lines * 26 + 14
    }

    onLinesChanged: {
        heightAnimation.targetLines = lines
        heightAnimation.restart()
    }

    onWidthChanged: {
        if (lineWidthAuto) lineWidth = (width - 20) / 12
    }

    onHexFilterChanged: wTextFieldText.validate()
    onNumFilterChanged: wTextFieldText.validate()
    onStrictLineWidthChanged: wTextFieldText.validate()

    onMaxTotalLengthChanged: wTextFieldText.validate()

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

            function setTextWidth(textIn: string) {
                let lineWidth = Math.round(wTextField.lineWidth)
                let lineIndex = 0
                for (let i = 0; i < textIn.length; ++i) {
                    if (textIn[i] === '\n') {
                        if (lineIndex === lineWidth && i !== textIn.length - 1) {
                            lineIndex = 0
                            continue
                        }
                        if (wTextField.strictLineWidth) {
                            textIn = textIn.slice(0, i) + textIn.slice(i + 1)
                            --i
                        } else {
                            lineIndex = 0
                        }
                        continue
                    }
                    if (lineIndex === lineWidth) {
                        textIn = textIn.slice(0, i) + '\n' + textIn.slice(i)
                        ++i
                        lineIndex = 0
                        continue
                    }
                    ++lineIndex
                }
                return textIn
            }

            function filter(textIn: string, rule: string) {
                rule += '\n'
                for (let i = 0; i < textIn.length; ++i) {
                    if (rule.indexOf(textIn[i]) === -1) {
                        textIn = textIn.slice(0, i) + textIn.slice(i + 1)
                        --i
                    }
                }
                return textIn
            }

            function limitTotalLength(textIn: string) {
                let maxLen = wTextField.maxTotalLength
                if (strictLineWidth) {
                    maxLen += wTextField.lines - 1
                }
                return textIn.substring(0, maxLen)
            }

            function validate() {
                let pos = cursorPosition
                let textLocal = text
                let rawTextLen = textLocal.length;
                if (wTextField.forceUpper) textLocal = textLocal.toUpperCase()
                if (wTextField.hexFilter) textLocal = filter(textLocal, '0123456789abcdefABCDEF')
                if (wTextField.numFilter) textLocal = filter(textLocal, '0123456789')
                textLocal = setTextWidth(textLocal, wTextField.lineWidth)
                if (wTextField.linesAuto) {
                    wTextField.lines = textLocal.split('\n').length
                    wTextField.lines = Math.min(wTextField.maxLines, wTextField.lines)
                }
                if (wTextField.maxTotalLength >= 0) textLocal = limitTotalLength(textLocal)
                else {
                    let splittedText = textLocal.split('\n')
                    textLocal = splittedText[0]
                    for (let i = 1; i < Math.min(wTextField.lines, splittedText.length); ++i) {
                        textLocal += '\n' + splittedText[i]
                    }
                }
                if (text !== textLocal) {
                    text = textLocal
                    cursorPosition = pos - (rawTextLen - text.length)
                }
            }

            onTextChanged: validate()

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
