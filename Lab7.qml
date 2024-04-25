import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    id: core

    Item {
        id: mk
        x: core.width * 0.5 - mkRaw.width / 2
        y: 50

        WTextField {
            id: mkRaw
            text: labCore7.getKey()
            lineWidth: 16
            lines: 2
        }
    }

    Item {
        id: kk1
        x: core.width * 0.75 - mkRaw.width / 2
        y: 150

        Column {
            spacing: 10

            WTextField {
                id: kk1Raw
                text: labCore7.getKey()
                lineWidth: 16
                lines: 2
            }

            WTextField {
                id: kk1Enc
                lineWidth: 16
                lines: 2
                readonly: true
            }
        }
    }

    Item {
        id: kk2
        x: core.width * 0.25 - mkRaw.width / 2
        y: 150

        Column {
            spacing: 10

            WTextField {
                id: kk2Raw
                text: labCore7.getKey()
                lineWidth: 16
                lines: 2
            }

            WTextField {
                id: kk2Enc
                lineWidth: 16
                lines: 2
                readonly: true
            }
        }
    }

    Item {
        id: dk1
        x: core.width * 0.13 - mkRaw.width / 2
        y: 350

        Column {
            spacing: 10

            WTextField {
                id: dk1Raw
                text: labCore7.getKey()
                lineWidth: 16
                lines: 2
            }

            WTextField {
                id: dk1Enc
                lineWidth: 16
                lines: 2
                readonly: true
            }
        }
    }


    Item {
        id: dk2
        x: core.width * 0.37 - mkRaw.width / 2
        y: 350

        Column {
            spacing: 10

            WTextField {
                id: dk2Raw
                text: labCore7.getKey()
                lineWidth: 16
                lines: 2
            }

            WTextField {
                id: dk2Enc
                lineWidth: 16
                lines: 2
                readonly: true
            }
        }
    }


    Item {
        id: dk3
        x: core.width * 0.63 - mkRaw.width / 2
        y: 350

        Column {
            spacing: 10

            WTextField {
                id: dk3Raw
                text: labCore7.getKey()
                lineWidth: 16
                lines: 2
            }

            WTextField {
                id: dk3Enc
                lineWidth: 16
                lines: 2
                readonly: true
            }
        }
    }

    Item {
        id: dk4
        x: core.width * 0.87 - mkRaw.width / 2
        y: 350

        Column {
            spacing: 10

            WTextField {
                id: dk4Raw
                text: labCore7.getKey()
                lineWidth: 16
                lines: 2
            }

            WTextField {
                id: dk4Enc
                lineWidth: 16
                lines: 2
                readonly: true
            }
        }
    }

    WButton {
        id: encryptBtn

        y: 600
        x: core.width * 0.5 - width / 2
        color: '#aaffaa'
        width: 200
        text: 'Encrypt'

        onClicked: {
            kk1Enc.text = labCore7.encrypt(mkRaw.text, kk1Raw.text);
            kk2Enc.text = labCore7.encrypt(mkRaw.text, kk2Raw.text);
            dk1Enc.text = labCore7.encrypt(kk1Enc.text, dk1Raw.text);
            dk2Enc.text = labCore7.encrypt(kk1Enc.text, dk2Raw.text);
            dk3Enc.text = labCore7.encrypt(kk2Enc.text, dk3Raw.text);
            dk4Enc.text = labCore7.encrypt(kk2Enc.text, dk4Raw.text);
        }
    }
}
