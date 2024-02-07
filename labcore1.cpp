#include "labcore1.h"
#include <QCryptographicHash>
#include <QRunnable>
#include <QThreadPool>
#include <QTime>
#include <QDebug>

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

QString LabCore1::validateHash(QString hashType, QString hash) {
    int hashSize = 0;
    if (hashType == "SHA1")
        hashSize = 40 + 2;
    else if (hashType == "SHA256")
        hashSize = 64 + 3;
    else if (hashType == "SHA512")
        hashSize = 128 + 7;
    else  // MD5 & <Empty>
        hashSize = 32 + 1;

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

QString LabCore1::hash(QString mode, QString key) {
    QByteArray byteHash;
    if (mode == "MD5") byteHash = QCryptographicHash::hash(key.toUtf8(), QCryptographicHash::Md5);
    else if (mode == "SHA1") byteHash = QCryptographicHash::hash(key.toUtf8(), QCryptographicHash::Sha1);
    else if (mode == "SHA256") byteHash = QCryptographicHash::hash(key.toUtf8(), QCryptographicHash::Sha256);
    else if (mode == "SHA512") byteHash = QCryptographicHash::hash(key.toUtf8(), QCryptographicHash::Sha512);
    char byteSigns[16] { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
    QString strHash;
    for (char& b : byteHash) {
        strHash.append(byteSigns[b >> 4 & 0x0f]);
        strHash.append(byteSigns[b & 0x0f]);
    }
    return strHash;
}

class LabCore1::RestoreTask : public QRunnable {
    LabCore1* core;
    QString mode;
    QString targetHash;

    void run() override {
        const char overflowChar = '9' + 1;
        const int totalIters = 11111110;
        const int progressPoint = totalIters * core->progressStep;
        int progress = 0;
        targetHash.remove('\n');
        int msStart = QTime::currentTime().msecsSinceStartOfDay();
        for (int keyLen = 1; keyLen<= 7; ++keyLen) {
            std::string key(keyLen, '0');
            std::string lastKey(keyLen, '9');
            while (key != lastKey) {
                QString iterHash = core->hash(mode, QString::fromStdString(key));
                if (iterHash == targetHash) {
                    emit core->keyFound(QString::fromStdString(key), QTime::currentTime().msecsSinceStartOfDay() - msStart);
                    return;
                }
                ++progress;
                if (progress % progressPoint == 0) {
                    emit core->progressChanged((float) progress / totalIters);
                }
                ++key[key.size() - 1];
                for (int i = key.size() - 1; i >= 0 && key[i] == overflowChar; --i) {
                    key[i] = '0';
                    ++key[i - 1];
                }
            }
        }
        emit core->keyFound("", 0);
    }

public:

    RestoreTask(LabCore1* core, QString mode, QString targetHash) : core(core), mode(mode), targetHash(targetHash) {}
};

void LabCore1::restore(QString mode, QString targetHash) {
    auto task = new RestoreTask(this, mode, targetHash);
    QThreadPool::globalInstance()->start(task);
}
