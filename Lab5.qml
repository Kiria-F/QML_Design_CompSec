import QtQuick
import QtQuick.Layouts

Item {
    Item {
        id: wSelector
        anchors.centerIn: parent
        property var model: [1, 2, 3, 4, 5]

        Row {
            spacing: 20
            anchors.centerIn: parent

            Repeater {
                model: wSelector.model

                WText {
                    id: wSelectorText
                    text: modelData
                }
            }
        }
    }
}
