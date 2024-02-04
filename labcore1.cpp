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
    return key;
}

QString LabCore1::validateHash(QString hash, int hashType) {
    int hashSize = 0;
    switch (hashType) {
    case 0:
        hashSize = 32;
        break;
    case 1:
        hashSize = 40;
        break;
    case 2:
        hashSize = 64;
        break;
    case 3:
        hashSize = 128;
        break;
    }
    for (int i = 0; i < hashType && i < hashSize; ++i) {
        if (!('0' <= hash[i] && hash[i] < '9' || 'a' <= hash[i] && hash[i] <= 'f')) {
            hash.remove(i, 1);
            --i;
        }
    }
    if (hash.size() > hashSize) {
        hash.resize(hashSize);
    }
    return hash;
}
