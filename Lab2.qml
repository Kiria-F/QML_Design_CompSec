import QtQuick

Item {
    anchors.fill: parent
    Text {
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        text: "Coming soon"
        opacity: 0.2
        font {
            family: "monospace"
            bold: true
            pixelSize: 50
        }
    }
}
