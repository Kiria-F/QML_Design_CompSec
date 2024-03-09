import QtQuick
import QtQuick.Layouts

Item {

    Column {
        width: 800
        anchors.centerIn: parent
        spacing: 20

        RowLayout {
            width: parent.width
            spacing: 20

            WText {
                text: 'Plain Text'
            }

            WTextField {
                Layout.fillWidth: true
            }
        }

        WPlatform {
            width: parent.width
            height: keysPlatform.height + 40

            RowLayout {
                id: keysPlatform
                width: parent.width - 40
                anchors.centerIn: parent
                spacing: 20

                WButton {
                    text: 'Generate'
                    width: 120

                    onClicked: {
                        labCore3.generatePair(4096);
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
                                    publicKeyTextField.key = key;
                                    publicKeyTextField.text = '…' + key.substring(32)
                                }
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
                            Layout.fillWidth: true
                            readonly: true
                        }

                        WButton {
                            text: 'Expand'
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
            height: textEncColumn.height + 40

            Column {
                id: textEncColumn
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
            height: textDecColumn.height + 40

            Column {
                id: textDecColumn
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
                }
            }
        }
    }

    WPopUp {
        id: popUp
        anchors.centerIn: parent
        width: 800
        height: 800
        autohide: false
        text.font.pixelSize: 18
    }
}
