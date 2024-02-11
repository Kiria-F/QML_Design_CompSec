import QtQuick
import QtQuick.Shapes

Item {
    Shape {
        anchors.centerIn: parent
        ShapePath {
            // Triangle with points: [a: {-311; -212}, b: {-121; 222}, c: {331; -232}]
            // BUT ROUNDED
            id: p
            property real ax: -311
            property real ay: -212
            property real bx: -121
            property real by: 222
            property real cx: 331
            property real cy: -232
            property real radius: 20
            fillColor: "gray"
            property var t1: geometry.arcConnect(radius, cx, cy, ax, ay, bx, by)
            startX: t1.lx
            startY: t1.ly
            PathArc { x: p.t1.ax; y: p.t1.ay; radiusX: p.radius; radiusY: p.radius; direction: PathArc.Counterclockwise }
            property var t2: geometry.arcConnect(radius, ax, ay, bx, by, cx, cy)
            PathLine { x: p.t2.lx; y: p.t2.ly }
            PathArc { x: p.t2.ax; y: p.t2.ay; radiusX: p.radius; radiusY: p.radius; direction: PathArc.Counterclockwise }
            property var t3: geometry.arcConnect(radius, bx, by, cx, cy, ax, ay)
            PathLine { x: p.t3.lx; y: p.t3.ly }
            PathArc { x: p.t3.ax; y: p.t3.ay; radiusX: p.radius; radiusY: p.radius; direction: PathArc.Counterclockwise }
        }
    }
}
