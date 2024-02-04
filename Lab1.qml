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
    Column {
        spacing: 10
        anchors.centerIn: parent
        WStateButton {
            id: b1
            text: "Press"
            onClicked: {
                text = "Pressed"
                b2.release()
                b3.release()
            }
            onReleased: {
                text = "Press"
            }
        }
        WStateButton {
            id: b2
            text: "Press"
            onClicked: {
                text = "Pressed"
                b1.release()
                b3.release()
            }
            onReleased: {
                text = "Press"
            }
        }
        WStateButton {
            id: b3
            text: "Press"
            onClicked: {
                text = "Pressed"
                b1.release()
                b2.release()
            }
            onReleased: {
                text = "Press"
            }
        }
    }
}
