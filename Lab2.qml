import QtQuick
import QtQuick.Layouts

Item {
    id: core
    property string cipherType
    property string cipherMode
    property string cipherPadding

    Column {
        spacing: 20
        anchors.centerIn: parent

        Row {
            id: cipherSetupRow
            spacing: 20

            WPlatform {
                id: cipherSetupTypePlatform
                width: cipherSetupTypeColumn.width + 60
                height: cipherSetupTypeColumn.height + 45
                property list<var> btnGroup: [btnDES, btn3DES, btnAES128, btnAES256]

                Column {
                    id: cipherSetupTypeColumn
                    spacing: 20
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top
                        topMargin: 20
                    }

                    WText {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Cipher Type"
                        color: constants.phantomTextColor
                    }

                    Column {
                        spacing: 10

                        Row {
                            spacing: 10

                            WStateButton {
                                id: btnDES
                                text: "DES"
                                group: cipherSetupTypePlatform.btnGroup

                                onClicked: {
                                    core.cipherType = text
                                }
                            }

                            WStateButton {
                                id: btn3DES
                                text: "3DES"
                                group: cipherSetupTypePlatform.btnGroup

                                onClicked: {
                                    core.cipherType = text
                                }
                            }
                        }

                        Row {
                            spacing: 10

                            WStateButton {
                                id: btnAES128
                                text: "AES128"
                                group: cipherSetupTypePlatform.btnGroup

                                onClicked: {
                                    core.cipherType = text
                                }
                            }

                            WStateButton {
                                id: btnAES256
                                text: "AES256"
                                group: cipherSetupTypePlatform.btnGroup

                                onClicked: {
                                    core.cipherType = text
                                }
                            }
                        }
                    }
                }
            }

            WPlatform {
                id: cipherSetupModePlatform
                width: cipherSetupModeColumn.width + 60
                height: cipherSetupModeColumn.height + 45
                property list<var> btnGroup: [btnCBC, btnECB, btnOFB, btnCFB]

                Column {
                    id: cipherSetupModeColumn
                    spacing: 20
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top
                        topMargin: 20
                    }

                    WText {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Cipher Mode"
                        color: constants.phantomTextColor
                    }

                    Column {
                        spacing: 10

                        Row {
                            spacing: 10

                            WStateButton {
                                id: btnCBC
                                text: "CBC"
                                group: cipherSetupModePlatform.btnGroup

                                onClicked: {
                                    core.cipherMode = text
                                }
                            }

                            WStateButton {
                                id: btnECB
                                text: "ECB"
                                group: cipherSetupModePlatform.btnGroup

                                onClicked: {
                                    core.cipherMode = text
                                }
                            }
                        }

                        Row {
                            spacing: 10

                            WStateButton {
                                id: btnOFB
                                text: "OFB"
                                group: cipherSetupModePlatform.btnGroup

                                onClicked: {
                                    core.cipherMode = text
                                }
                            }

                            WStateButton {
                                id: btnCFB
                                text: "CFB"
                                group: cipherSetupModePlatform.btnGroup

                                onClicked: {
                                    core.cipherMode = text
                                }
                                disabledCondition: core.cipherType === "3DES"
                            }
                        }
                    }
                }
            }

            WPlatform {
                id: cipherSetupPaddingPlatform
                width: cipherSetupPaddingColumn.width + 60
                height: cipherSetupPaddingColumn.height + 45
                property list<var> btnGroup: [btnNO, btnPKCS7, btnANSIX, btn1n0s]

                Column {
                    id: cipherSetupPaddingColumn
                    spacing: 20
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top
                        topMargin: 20
                    }

                    WText {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Padding"
                        color: constants.phantomTextColor
                    }

                    Row {
                        spacing: 10

                        Column {
                            spacing: 10

                            WStateButton {
                                id: btnNO
                                text: "NO"
                                group: cipherSetupPaddingPlatform.btnGroup

                                onClicked: {
                                    core.cipherPadding = text
                                }
                            }

                            WStateButton {
                                id: btnPKCS7
                                text: "PKCS7"
                                group: cipherSetupPaddingPlatform.btnGroup

                                onClicked: {
                                    core.cipherPadding = text
                                }
                            }
                        }

                        Column {
                            spacing: 10

                            WStateButton {
                                id: btnANSIX
                                text: "ANSIX"
                                group: cipherSetupPaddingPlatform.btnGroup

                                onClicked: {
                                    core.cipherPadding = text
                                }
                            }

                            WStateButton {
                                id: btn1n0s
                                text: "1&0s"
                                group: cipherSetupPaddingPlatform.btnGroup

                                onClicked: {
                                    core.cipherPadding = text
                                }
                            }
                        }
                    }
                }
            }
        }

        WPlatform {
            id: cipherKeysPlatform
            width: parent.width
            height: cipherKeysColumn.height + 60

            Column {
                id: cipherKeysColumn
                spacing: 20
                width: parent.width - 60
                anchors.centerIn: parent

                RowLayout {
                    spacing: 20
                    width: parent.width

                    WText {
                        text: "Init Vector"
                    }

                    WTextField {
                        id: vectorField
                        Layout.fillWidth: true
                    }

                    WButton {
                        id: genVectorBtn
                        text: "Auto"

                        onClicked: {
                            vectorField.text = labCore2.genInitVector(core.cipherType);
                        }
                    }
                }

                RowLayout {
                    spacing: 20
                    width: parent.width

                    WText {
                        text: "Key"
                    }

                    WTextField {
                        id: keyField
                        Layout.fillWidth: true
                    }

                    WButton {
                        id: genKeyBtn
                        text: "Auto"

                        onClicked: {
                            keyField.text = labCore2.genKey(core.cipherType)
                        }
                    }
                }
            }
        }

        WPlatform {
            id: cipherTextPlatform
            width: parent.width
            height: cipherTextColumn.height + 60
            state: "0"

            states: [
                State {
                    name: "0"  // encrypt

                    PropertyChanges {
                        target: runBtn
                        text: "Encrypt"
                    }

                    PropertyChanges {
                        target: textFieldLabel
                        text: "Text"
                    }

                    PropertyChanges {
                        target: codeFieldLabel
                        text: "Code"
                    }
                },
                State {
                    name: "1"  // decrypt

                    PropertyChanges {
                        target: runBtn
                        text: "Decrypt"
                    }

                    PropertyChanges {
                        target: textFieldLabel
                        text: "Code"
                    }

                    PropertyChanges {
                        target: codeFieldLabel
                        text: "Text"
                    }
                }
            ]

            Column {
                id: cipherTextColumn
                spacing: 20
                width: parent.width - 60
                anchors.centerIn: parent

                RowLayout {
                    spacing: 20
                    width: parent.width

                    WText {
                        id: textFieldLabel
                        text: "Text"
                    }

                    WTextField {
                        id: textField
                        Layout.fillWidth: true
                    }
                }

                Row {
                    spacing: 20
                    anchors.horizontalCenter: parent.horizontalCenter

                    WButton {
                        text: "Swap"

                        onClicked: {
                            cipherTextPlatform.state = 1 - cipherTextPlatform.state
                            textField.text = codeField.text
                            codeField.text = ""
                        }
                    }

                    WButton {
                        id: runBtn
                        text: "Encrypt"
                        width: 200
                        color: "#ccffaa"

                        onClicked: {
                            var dir
                            if (cipherTextPlatform.state === "0") dir = "ENCRYPT"
                            else dir = "DECRYPT"
                            codeField.text = labCore2.process(core.cipherType, core.cipherMode, core.cipherPadding, vectorField.text, keyField.text, textField.text, dir)
                        }
                    }
                }

                RowLayout {
                    spacing: 20
                    width: parent.width

                    WText {
                        id: codeFieldLabel
                        text: "Code"
                    }

                    WTextField {
                        id: codeField
                        Layout.fillWidth: true
                        readonly: true
                    }
                }
            }
        }
    }
}
