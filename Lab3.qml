import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

Item {

    Column {
        width: encryptedTextContainer.width
        anchors.centerIn: parent
        spacing: 20

        WPlatform {
            width: parent.width
            height: textContainer.height + 40

            Column {
                id: textContainer
                width: parent.width
                anchors.verticalCenter: parent.verticalCenter
                spacing: 20

                WText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: 'Plain Text'
                }

                WTextField {
                    id: plainTextField
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 40
                    linesAuto: true
                }
            }
        }

        WPlatform {
            width: parent.width
            height: keysContainer.height + 40

            RowLayout {
                id: keysContainer
                width: parent.width - 40
                anchors.centerIn: parent
                spacing: 20

                Column {
                    spacing: 20

                    RowLayout {
                        spacing: 10

                        WText {
                            text: 'Size'
                        }

                        WTextField {
                            id: keySizeTextField
                            lineWidth: 4
                            text: '2048'
                        }
                    }

                    WButton {
                        text: 'Generate'
                        width: 120

                        onClicked: {
                            publicKeyTextFieldBusy.running = true
                            privateKeyTextFieldBusy.running = true
                            labCore3.generatePair(keySizeTextField.text);
                        }
                    }
                }

                Column {
                    spacing: 20
                    Layout.fillWidth: true

                    RowLayout {
                        spacing: 20
                        width: parent.width

                        WText {
                            text: ' Public Key'
                        }

                        WTextField {
                            id: publicKeyTextField
                            Layout.fillWidth: true
                            readonly: true
                            property string key

                            Connections {
                                target: labCore3

                                function onPublicKeyGenerated(key: string) {
                                    publicKeyTextFieldBusy.running = false
                                    publicKeyTextField.key = key;
                                    publicKeyTextField.text = '…' + key.substring(32)
                                }
                            }

                            BusyIndicator {
                                id: publicKeyTextFieldBusy
                                anchors.centerIn: parent
                                scale: 0.8
                                running: false
                            }
                        }

                        WButton {
                            text: 'Expand'
                            onClicked: popUp.show(publicKeyTextField.key.substring(0, publicKeyTextField.key.length - 1))
                        }
                    }

                    RowLayout {
                        spacing: 20
                        width: parent.width

                        WText {
                            text: 'Private Key'
                        }

                        WTextField {
                            id: privateKeyTextField
                            Layout.fillWidth: true
                            readonly: true
                            property string key

                            Connections {
                                target: labCore3

                                function onPrivateKeyGenerated(key: string) {
                                    privateKeyTextFieldBusy.running = false
                                    privateKeyTextField.key = key;
                                    privateKeyTextField.text = '…' + key.substring(32)
                                }
                            }

                            BusyIndicator {
                                id: privateKeyTextFieldBusy
                                anchors.centerIn: parent
                                scale: 0.8
                                running: false
                            }
                        }

                        WButton {
                            text: 'Expand'
                            onClicked: popUp.show(privateKeyTextField.key.substring(0, privateKeyTextField.key.length - 1))
                        }
                    }
                }
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20

            WButton {
                width: 150
                text: 'Encrypt'
                color: '#aaffaa'

                onClicked: {
                    encryptedTextField.rawText = labCore3.encrypt(plainTextField.text, publicKeyTextField.key)
                    encryptedTextField.text = encryptedTextField.rawText
                }
            }

            WButton {
                width: 200
                text: 'Encrypt file'

                onClicked: {
                    encryptFileDialog.open()
                }

                FileDialog {
                    id: encryptFileDialog
                    title: "Please choose a file"
                    currentFolder: "file:///home/f/Documents"
                    onAccepted: {
                        var source = ioFile.read(encryptFileDialog.selectedFile)
                        var encrypted = labCore3.encrypt(source, publicKeyTextField.key)
                        var target = encryptFileDialog.selectedFile + "-enc"
                        ioFile.write(target, encrypted)
                        lightPopUp.show("Encrypted to\n" + target.substring(target.lastIndexOf("/") + 1))
                    }
                }
            }
        }

        WPlatform {
            width: encryptedTextContainer.width
            height: encryptedTextContainer.height + 40

            Column {
                id: encryptedTextContainer
                width: encryptedTextField.width + 40
                anchors.centerIn: parent
                spacing: 20

                WText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: 'Encrypted Text'
                }

                WTextField {
                    id: encryptedTextField
                    anchors.horizontalCenter: parent.horizontalCenter
                    readonly: true
                    linesAuto: true
                    forceUpper: true
                    strictLineWidth: true
                    lineWidth: 64
                    property string rawText
                }
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20

            WButton {
                width: 150
                text: 'Decrypt'
                color: '#aaffaa'

                onClicked: {
                    decryptedTextField.text = labCore3.decrypt(encryptedTextField.rawText, privateKeyTextField.key)
                }
            }

            WButton {
                width: 200
                text: 'Decrypt file'

                onClicked: {
                    decryptFileDialog.open()
                }

                FileDialog {
                    id: decryptFileDialog
                    title: "Please choose a file"
                    currentFolder: "file:///home/f/Documents"
                    onAccepted: {
                        var source = ioFile.read(decryptFileDialog.selectedFile)
                        var decrypted = labCore3.decrypt(source, privateKeyTextField.key)
                        var target = decryptFileDialog.selectedFile + "-dec"
                        ioFile.write(target, decrypted)
                        lightPopUp.show("Decrypted to\n" + target.substring(target.lastIndexOf("/") + 1))
                    }
                }
            }
        }

        WPlatform {
            width: parent.width
            height: decrypedTextContainer.height + 40

            Column {
                id: decrypedTextContainer
                width: parent.width - 40
                anchors.centerIn: parent
                spacing: 20

                WText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: 'Decrypted Text'
                }

                WTextField {
                    id: decryptedTextField
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    readonly: true
                    linesAuto: true
                }
            }
        }
    }

    WPopUp {
        id: lightPopUp
        anchors.centerIn: parent
        width: text.width + 200
        height: text.height + 100
        text.font.pixelSize: 25
    }

    WPopUp {
        id: popUp
        anchors.centerIn: parent
        width: text.width + 60
        height: text.height + 60
        autohide: false
        text.font.pixelSize: 18
    }
}
