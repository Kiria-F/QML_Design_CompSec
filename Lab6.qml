import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: core
    property list<var> chain: []
    signal mine(prevHas: string, note: string, targetPrefixLength: int)

    Component.onCompleted: {
        mine.connect(labCore6.mine);
    }

    Connections {
        target: labCore6

        function onMined(chainNode) {
            core.chain.push(chainNode)
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 20

        RowLayout {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter

            WText {
                text: 'Target prefix length'
                Layout.alignment: Qt.AlignVCenter
            }

            WTextField {
                id: tplInput
                text: '3'
                numFilter: true
                lineWidth: 1
            }
        }

        ListView {
            id: chainList
            model: core.chain
            spacing: 10
            width: 800
            anchors.horizontalCenter: parent.horizontalCenter
            height: core.height * 0.8
            clip: true

            delegate: ItemDelegate {
                id: node
                width: chainList.width
                height: nodePlate.height
                required property var modelData

                WPlatform {
                    id: nodePlate
                    width: parent.width - 10
                    height: nodePlateColumn.height + 20
                    anchors.horizontalCenter: parent.horizontalCenter

                    Column {
                        id: nodePlateColumn
                        spacing: 10
                        anchors.verticalCenter: parent.verticalCenter
                        leftPadding: 20
                        rightPadding: 20

                        Row {
                            spacing: 10

                            WText {
                                text: 'Nonce:'
                            }

                            WText {
                                text: modelData.nonce
                            }
                        }

                        Row {
                            spacing: 10

                            WText {
                                text: 'Note:'
                            }

                            WText {
                                text: modelData.note
                            }
                        }

                        Row {
                            spacing: 10

                            WText {
                                text: 'Prev. hash:'
                            }

                            WText {
                                text: modelData.prevHash
                            }
                        }

                        Row {
                            spacing: 10

                            WText {
                                text: 'Hash:'
                            }

                            WText {
                                text: modelData.hash
                            }
                        }
                    }
                }
            }
        }

        Row {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter

            WTextField {
                id: noteInput
                placeholder: 'Note'
                lineWidth: 20
            }

            WButton {
                color: '#aaffaa'
                text: 'Mine'

                onClicked: {
                    if (chain.length == 0) {
                        core.mine('0'.repeat(32), noteInput.text, tplInput.text)
                    } else {
                        core.mine(core.chain[chain.length - 1].hash, noteInput.text, tplInput.text)
                    }
                }
            }
        }
    }
}
