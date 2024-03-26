import QtQuick
import QtQuick.Controls

Item {
    id: core
    property list<string> certs: labCore4.getAll()
    property list<string> filtered

    ScrollView {
        id: container
        anchors.centerIn: parent
        width: 800
        height: 800

        ListView {
            model: labCore4.getAll()
            spacing: 10
            delegate: ItemDelegate {
                width: container.width
                height: certName.height

                WText {
                    id: certName
                    text: modelData
                    color: parent.hovered ? constants.strongTextColor : constants.weakTextColor
                }
            }
        }
    }
}
