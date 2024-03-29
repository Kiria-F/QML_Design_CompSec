    #include "labcore1.h"
#include <QCryptographicHash>
#include <QRunnable>
#include <QThreadPool>
#include <QTime>
#include <QDebug>

LabCore1::LabCore1(QObject *parent)
    : QObject{parent}
{}

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

void RestoreTask::run() {
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
                emit restored(QString::fromStdString(key), QTime::currentTime().msecsSinceStartOfDay() - msStart, mode);
                return;
            }
            if (displayProgress) {
                ++progress;
                if (progress % progressPoint == 0) {
                    emit core->progressChanged((float) progress / totalIters);
                }
            }
            ++key[key.size() - 1];
            for (int i = key.size() - 1; i >= 0 && key[i] == overflowChar; --i) {
                key[i] = '0';
                ++key[i - 1];
            }
        }
    }
    emit restored("", -1, mode);
}

void LabCore1::restore(QString mode, QString targetHash) {
    auto task = new RestoreTask(this, mode, targetHash, true);
    QObject::connect(task, &RestoreTask::restored, this, &LabCore1::keyFound);
    QThreadPool::globalInstance()->start(task);
}

void LabCore1::calcGraph(QString mode) {
    auto task = new RestoreTask(this, mode, hash(mode, "500000"), false);
    QObject::connect(task, &RestoreTask::restored, this, &LabCore1::calcGraphApprox);
    QThreadPool::globalInstance()->start(task);
}
void LabCore1::calcGraphApprox(QString key, int ms, QString mode) {
    QList<int> mss { 0 };
    for (int i = 1; i < 10; ++i) {
        mss.append(int(ms * std::pow(10, i - 6)) | 1);
    }
    emit graphCalced(mode, mss);
}
