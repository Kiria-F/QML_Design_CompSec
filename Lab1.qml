import QtQuick
import QtQuick.Shapes
import QtQuick.Controls

Item {
    Column {
        anchors.centerIn: parent
        StackView {
            id: sv
            width: 200
            height: 200
            initialItem: Rectangle {
                width: 200
                height: 200
                color: "gray"
            }
        }
        Row {
            Button {
                text: "G"
                onClicked: sv.replace(gr)
            }
            Button {
                text: "B"
                onClicked: sv.replace(br)
            }
            Button {
                text: ">"
                onClicked: sv.pop()
            }
        }
        Rectangle {
            id: gr
            color: "green"
            width: 200
            height: 200
        }
        Rectangle {
            id: br
            color: "black"
            width: 200
            height: 200
        }
    }

    Shape {
        //anchors.centerIn: parent
        anchors.fill: parent
        opacity: 0.2
    }
}
