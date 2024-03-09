import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {

    Column {
        width: 800
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

                WButton {
                    text: 'Generate'
                    width: 120

                    onClicked: {
                        publicKeyTextFieldBusy.running = true
                        privateKeyTextFieldBusy.running = true
                        labCore3.generatePair(2048);
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
                            onClicked: popUp.show(publicKeyTextField.key)
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
                            onClicked: popUp.show(privateKeyTextField.key)
                        }
                    }
                }

            }
        }

        WButton {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 150
            text: 'Encrypt'
            color: '#aaffaa'
        }

        WPlatform {
            width: parent.width
            height: textEncContainer.height + 40

            Column {
                id: textEncContainer
                width: parent.width - 40
                anchors.centerIn: parent
                spacing: 20

                WText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: 'Encrypted Text'
                }

                WTextField {
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    readonly: true
                    linesAuto: true
                }
            }
        }

        WButton {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 150
            text: 'Decrypt'
            color: '#aaffaa'
        }

        WPlatform {
            width: parent.width
            height: textDecContainer.height + 40

            Column {
                id: textDecContainer
                width: parent.width - 40
                anchors.centerIn: parent
                spacing: 20

                WText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: 'Decrypted Text'
                }

                WTextField {
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    readonly: true
                    linesAuto: true
                }
            }
        }
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
