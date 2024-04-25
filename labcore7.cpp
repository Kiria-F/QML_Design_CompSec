#include "labcore7.h"

LabCore7::LabCore7(QObject *parent) : QObject(parent), qRandomGenerator() {}

QString LabCore7::getKey() {
    QByteArray key(16, 0);
    for (int i = 0; i < 16; ++i) {
        key[i] = qRandomGenerator.bounded(0x100);
    }
    return QCA::arrayToHex(key).toUpper();
}

QString LabCore7::encrypt(QString key, QString data) {
    QCA::Cipher cipher(
        "tripledes",
        QCA::Cipher::ECB,
        QCA::Cipher::NoPadding,
        QCA::Encode,
        QCA::hexToArray(key.remove("\n").toLower()),
        QCA::hexToArray("2020202020202020"));
    return QCA::arrayToHex(cipher.process(QCA::hexToArray(data.remove("\n").toLower())).toByteArray()).toUpper();
}
