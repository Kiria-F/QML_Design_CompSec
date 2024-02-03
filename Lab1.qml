import QtQuick
import QtQuick.Shapes

Item {
    anchors.fill: parent

    Shape {
        //anchors.centerIn: parent
        anchors.fill: parent
        opacity: 0.2

        ShapePath {
            fillColor: "black"

            PathLine { x: 0; y: 0 }
            PathLine { x: width; y: 0 }
            PathLine { x: width; y: height }
            PathLine { x: 0; y: height }
        }
    }
}
