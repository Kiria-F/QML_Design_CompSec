import QtQuick
import QtQuick.Layouts

Item {
    WPlatform {
        id: platform
        width: 300
        height: column.height + 60

        Column {
            id: column
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
                    hexFilter: true
                    forceUpper: true
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
                    hexFilter: true
                    forceUpper: true
                    lineWidth: 32
                    lineWidthAuto: false
                    // strictLineWidth: true
                    linesAuto: true
                    Layout.preferredHeight: height
                }
            }
        }
    }
}
