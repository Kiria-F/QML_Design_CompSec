import QtQuick
import QtQuick.Shapes

Item {
    Column {
        anchors.centerIn: parent

        Shape {
            opacity: 0.075
            width: lpPath.w
            height: lpPath.h
            anchors.horizontalCenter: parent.horizontalCenter
            antialiasing: true

            ShapePath {
                id: lpPath
                fillColor: "black"

                property real fat: 0.7
                property real arrowSize: 0.4
                property real w: 300
                property real h: 400
                property real r: 10

                startX: w / 2 - w / 2 * fat + r
                startY: h
                PathArc { relativeX: -lpPath.r; relativeY: -lpPath.r; radiusX: lpPath.r; radiusY: lpPath.r }
                PathLine { relativeX: 0; y: lpPath.h * lpPath.arrowSize + lpPath.r}
                PathArc { relativeX: -lpPath.r; relativeY: -lpPath.r; direction: PathArc.Counterclockwise; radiusX: lpPath.r; radiusY: lpPath.r }
                property var t1: geometry.arcConnect(r, startX, h * arrowSize, 0, h * arrowSize, w / 2, 0)
                PathLine { x: lpPath.t1.lx; y: lpPath.t1.ly }
                PathArc { x: lpPath.t1.ax; y: lpPath.t1.ay; radiusX: lpPath.r; radiusY: lpPath.r }
                property var t2: geometry.arcConnect(r, 0, h * arrowSize, w / 2, 0, w, h * arrowSize)
                PathLine { x: lpPath.t2.lx; y: lpPath.t2.ly }
                PathArc { x: lpPath.t2.ax; y: lpPath.t2.ay; radiusX: lpPath.r; radiusY: lpPath.r }
                property var t3: geometry.arcConnect(r, w / 2, 0, w, h * arrowSize, w - startX, h * arrowSize)
                PathLine { x: lpPath.t3.lx; y: lpPath.t3.ly }
                PathArc { x: lpPath.t3.ax; y: lpPath.t3.ay; radiusX: lpPath.r; radiusY: lpPath.r }
                PathLine { x: lpPath.w / 2 + lpPath.w / 2 * lpPath.fat + lpPath.r ; relativeY: 0 }
                PathArc { relativeX: -lpPath.r; relativeY: lpPath.r; direction: PathArc.Counterclockwise; radiusX: lpPath.r; radiusY: lpPath.r }
                PathLine { relativeX: 0; y: lpPath.h - lpPath.r }
                PathArc { relativeX: -lpPath.r; relativeY: lpPath.r; radiusX: lpPath.r; radiusY: lpPath.r }
                PathLine { x: lpPath.startX; y: lpPath.startY }
            }
        }

        Text {
            text: "Choose a lab"
            opacity: 0.2
            font {
                family: constants.fontFamily
                bold: true
                pixelSize: 50
            }
        }
    }
}
