import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: core
    property list<string> certs: labCore4.getAll()
    property list<string> filtered

    ColumnLayout {
        anchors.centerIn: parent
        width: 800
        height: 800
        spacing: 20

        Component.onCompleted: {
            filterInput.textChanged()
        }

        WTextField {
            id: filterInput
            width: parent.width
            placeholder: 'Filter'

            onTextChanged: {
                core.filtered = core.certs.filter(c => c.toLowerCase().includes(text.toLowerCase()))
            }
        }

        WPlatform {
            Layout.fillHeight: true
            width: parent.width

            ScrollView {
                id: container
                anchors {
                    fill: parent
                    margins: 20
                }

                ListView {
                    model: core.filtered
                    spacing: 10
                    delegate: ItemDelegate {
                        width: container.width
                        height: certName.height

                        WText {
                            id: certName
                            text: modelData
                            color: parent.hovered ? constants.strongTextColor : constants.weakTextColor
                        }

                        onClicked: {
                            popUp.verified = labCore4.verify(certName.text)
                            popUp.show(labCore4.getOne(certName.text))
                        }
                    }
                }
            }
        }
    }

    WPopUp {
        id: popUp
        anchors.centerIn: parent
        width: text.width + 60
        height: text.height + 60
        autohide: false
        text.font.pixelSize: 18
        property bool verified: true

        WText {
            anchors.centerIn: parent
            text: popUp.verified ? "VERIFIED" : "ERROR"
            color: popUp.verified ? "#6600ff00" : "#66ff0000"
            font.pixelSize: constants.fontSize * 6
        }
    }
}
