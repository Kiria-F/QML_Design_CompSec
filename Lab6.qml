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

    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            spacing: 10
            Layout.alignment: Qt.AlignHCenter

            WText {
                text: 'Target prefix length'
                Layout.alignment: Qt.AlignVCenter
            }

            WTextField {
                id: tpl
                text: '3'
                numFilter: true
                lineWidth: 1
            }
        }

        ListView {
            model: core.chain
            spacing: 10
            width: 800
            Layout.alignment: Qt.AlignHCenter
            // Layout.preferredHeight: Layout.maximumHeight
            height: 500

            delegate: ItemDelegate {
                id: node
                width: parent.width
                height: nodePlate.height
                required property var modelData

                WPlatform {
                    id: nodePlate
                    width: parent.width
                    height: 100

                    WText {
                        text: modelData.hash
                    }
                }
            }
        }

        Row {
            spacing: 10
            Layout.alignment: Qt.AlignHCenter

            WTextField {
                placeholder: 'Note'
            }

            WButton {
                color: '#aaffaa'
                text: 'Mine'

                onClicked: {
                    if (chain.length == 0) {
                        core.mine('0'.repeat(32), 'Init', 3)
                    } else {
                        core.mine(core.chain[chain.length - 1].hash, 'test', 3)
                    }
                }
            }
        }
    }
}
