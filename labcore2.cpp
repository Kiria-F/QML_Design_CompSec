#include "labcore2.h"
#include <Qca-qt6/QtCrypto/QtCrypto>
#include <QDebug>

LabCore2::LabCore2(QObject *parent)
    : QObject{parent}, qRandomGenerator()
{}

QByteArray LabCore2::addPadding(QByteArray text, QString mode) {
    if (mode == "NO") return text;
    int blockSize = mode.contains("AES") ? 16 : 8;
    int newSize = (text.size() / blockSize + 1) * blockSize;
    int tailSize = newSize - text.size();
    if (mode == "PKCS5") {
        return text.append(tailSize, tailSize);
    }
    if (mode == "1&0s") {
        return text.append(0x80).append(tailSize - 1, 0);
    }
    if (mode == "ANSIX") {
        return text.append(tailSize - 1, 0).append(tailSize);
    }
    if (mode == "W3C") {
        QRandomGenerator rand;
        for (int i = 0; i < tailSize - 1; ++i) {
            text.append(rand.bounded(0x100));
        }
        return text.append(tailSize);
    }
    qWarning() << "INCORRECT PADDING";
    return text;
}

QByteArray LabCore2::removePadding(QByteArray text, QString mode) {
    if (mode == "NO") return text;
    if (mode == "PKCS5" || mode == "ANSIX" || mode == "W3C") {
        return text.chopped(text[text.size() - 1]);
    }
    if (mode == "1&0s") {
        int i = text.size() - 1;
        while (text[i] != char(0x80)) { --i; }
        return text.chopped(text.size() - i);
    }
    qWarning() << "INCORRECT PADDING";
    return text;
}

QString LabCore2::process(QString typeStr, QString modeStr, QString paddingModeStr, QString initVectorStr, QString keyStr, QString textStr, QString directionStr, bool byteText) {
    QString type;
    if (typeStr == "DES") type = "des";
    else if (typeStr == "3DES") type = "tripledes";
    else if (typeStr == "AES128") type = "aes128";
    else if (typeStr == "AES256") type = "aes256";
    else {
        qWarning() << "INCORRECT TYPE";
        return "";
    }
    QCA::Cipher::Mode mode;
    if (modeStr == "CBC") mode = QCA::Cipher::CBC;
    else if (modeStr == "ECB") mode = QCA::Cipher::ECB;
    else if (modeStr == "OFB") mode = QCA::Cipher::OFB;
    else if (modeStr == "CFB") mode = QCA::Cipher::CFB;
    else {
        qWarning() << "INCORRECT MODE";
        return "";
    }
    QCA::Cipher::Padding paddingMode = QCA::Cipher::NoPadding;
    QCA::InitializationVector initVector(QCA::hexToArray(initVectorStr));
    QCA::SymmetricKey key(QCA::hexToArray(keyStr));
    QCA::Direction direction;
    if (directionStr == "ENCRYPT") direction = QCA::Encode;
    else if (directionStr == "DECRYPT") direction = QCA::Decode;
    else {
        qWarning() << "INCORRECT DIRECTION";
        return "";
    }

    QByteArray text;
    if (!direction) text = addPadding(byteText ? QCA::hexToArray(textStr) : textStr.toUtf8(), paddingModeStr);
    else text = QCA::hexToArray(textStr);

    QCA::Cipher cipher(type, mode, paddingMode, direction, key, initVector);
    QByteArray result = cipher.process(text).toByteArray();

    if (!direction) return QCA::arrayToHex(result);
    result = removePadding(result, paddingModeStr);
    return byteText ? QCA::arrayToHex(result) : QString::fromUtf8(result);
}

QString LabCore2::genInitVector(QString type) {
    return type.contains("AES") ? genKey(16) : genKey(8);
}

QString LabCore2::genKey(QString type) {
    if (type == "DES") return genKey(8);
    if (type == "3DES") return genKey(16);
    if (type == "AES128") return genKey(16);
    if (type == "AES256") return genKey(32);
    qWarning() << "INCORRECT TYPE";
    return "";
}

QString LabCore2::genKey(int bytes) {
    QByteArray key(bytes, 0);
    for (int i = 0; i < bytes; ++i) {
        key[i] = qRandomGenerator.bounded(0x100);
    }
    return QCA::arrayToHex(key);
}
