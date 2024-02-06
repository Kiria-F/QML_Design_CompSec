#include <QDebug>
#include "labcore1.h"

LabCore1::LabCore1(QObject *parent)
    : QObject{parent}
{}

QString LabCore1::validateKey(QString key) {
    for (int i = 0; i < key.size(); ++i) {
        if (!('0' <= key[i] && key[i] <= '9')) {
            key.remove(i, 1);
            --i;
        }
    }
    if (key.size() > 7) {
        key.resize(7);
    }
    qDebug() << "key";
    return key;
}

QString LabCore1::validateHash(QString hashType, QString hash) {
    int hashSize = 0;
    if (hashType == "MD5")
        hashSize = 32 + 1;
    else if (hashType == "SHA1")
        hashSize = 40 + 2;
    else if (hashType == "SHA256")
        hashSize = 64 + 3;
    else if (hashType == "SHA512")
        hashSize = 128 + 7;

    for (int i = 0; i < hash.size() && i < hashSize; ++i) {
        if ((i + 1) % 17 == 0 && i > 0) {
            if (hash[i] != '\n') {
                hash.insert(i, '\n');
            }
        }
        else if (!('0' <= hash[i] && hash[i] <= '9' || 'a' <= hash[i] && hash[i] <= 'f')) {
            hash.remove(i, 1);
            --i;
        }
    }
    if (hash.size() > hashSize) {
        hash.resize(hashSize);
    }
    return hash;
}
