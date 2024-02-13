import QtQuick

Item {
    Text {
        anchors.centerIn: parent

        WButton {
            onClicked: {
                labCore2.test()
            }
        }
    }
}
