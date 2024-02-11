import QtQuick
import QtQuick.Shapes

Item {
    Column {
        spacing: 5

        Repeater {
            model: 9

            WTextField {
                length: index + 1
                placeholder: "0".repeat(index + 1)
            }
        }
    }
}
