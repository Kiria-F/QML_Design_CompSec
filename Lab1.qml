import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import QtQuick.Controls

Item {
    TextField {
        anchors {
            left: parent.left
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }
        validator: RegularExpressionValidator { regularExpression: /^[\d]{1,9}$/ }
        font {
            family: "monospace"
            bold: true
            pixelSize: 20
        }
    }

    WButton {
        anchors.centerIn: parent
        text: "Press"
        onClicked: {
            text = "Pressed"
        }
    }
}
