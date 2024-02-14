import QtQuick

Item {
    id: core
    property list<string> cipherSetup: ["", "", ""]

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
                        text: "Cipther Type"
                    }

                    Column {
                        spacing: 10

                        Row {
                            spacing: 10

                            WButton {

                            }

                            WButton {

                            }
                        }

                        Row {
                            spacing: 10

                            WButton {

                            }

                            WButton {

                            }
                        }
                    }
                }
            }

            WPlatform {
                width: 200;
                height: 200

                WText {
                    y: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Cipher Mode"
                }
            }

            WPlatform {
                width: 200;
                height: 200

                WText {
                    y: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Cipher Align"
                }
            }
        }

        WPlatform {
            width: parent.width
            height: 500

            WText {
                y: 10
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Bottom platform".toUpperCase()
            }
        }
    }
}
