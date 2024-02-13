#ifndef TOOLS_H
#define TOOLS_H

#include <QByteArray>
#include <QString>
#include <QDebug>

class Tools {

    static char c2i(char c) {
        switch (c) {
        case '0': return 0x0;
        case '1': return 0x1;
        case '2': return 0x2;
        case '3': return 0x3;
        case '4': return 0x4;
        case '5': return 0x5;
        case '6': return 0x6;
        case '7': return 0x7;
        case '8': return 0x8;
        case '9': return 0x9;
        case 'a': return 0xa;
        case 'b': return 0xb;
        case 'c': return 0xc;
        case 'd': return 0xd;
        case 'e': return 0xe;
        case 'f': return 0xf;
        default: qWarning() << "C2I UNHANDLED VALUE [" << c << "]";
        }
        return 0;
    }

    static char i2c(char i) {
        switch (i) {
        case 0x0: return '0';
        case 0x1: return '1';
        case 0x2: return '2';
        case 0x3: return '3';
        case 0x4: return '4';
        case 0x5: return '5';
        case 0x6: return '6';
        case 0x7: return '7';
        case 0x8: return '8';
        case 0x9: return '9';
        case 0xa: return 'a';
        case 0xb: return 'b';
        case 0xc: return 'c';
        case 0xd: return 'd';
        case 0xe: return 'e';
        case 0xf: return 'f';
        default: qWarning() << "I2C UNHANDLED VALUE [" << i << "]";
        }
        return 0;
    }

public:

    static QByteArray str2qba(QString qstr) {
        std::string str = qstr.toStdString();
        int arrSize = str.size() / 2;
        QByteArray arr(arrSize, 0);
        for (int i = 0; i < arrSize; ++i) {
            arr[i] = c2i(str[i * 2]) << 4;
            qDebug() << "arr[" << i << "] <- " << int(arr[i]);
            arr[i] += c2i(str[i * 2 + 1]);
            qDebug() << "arr[" << i << "] <- " << int(arr[i]);
        }
        return arr;
    }

    static QString qba2str(QByteArray arr) {
        int arrSize = arr.size();
        std::string str(arrSize * 2, '0');
        for (int i = 0; i < arrSize; ++i) {
            str[i * 2] = i2c(arr[i] >> 4 & 0xf);
            str[i * 2 + 1] = i2c(arr[i] & 0xf);
        }
        return QString::fromStdString(str);
    }
};

#endif // TOOLS_H
