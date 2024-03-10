#include "labcore3.h"
#include <Qca-qt6/QtCrypto/QtCrypto>

LabCore3::LabCore3(QObject *parent) : QObject{parent} {
    worker.moveToThread(&workerThread);

    connect(this, &LabCore3::workerGeneratePair, &worker, &Worker::generatePair);
    connect(&worker, &Worker::publicKeyGenerated, this, &LabCore3::publicKeyGenerated);
    connect(&worker, &Worker::privateKeyGenerated, this, &LabCore3::privateKeyGenerated);

    workerThread.start();
}

LabCore3::~LabCore3() {
    workerThread.quit();
    workerThread.wait();
}

void Worker::generatePair(int bits) {
    QCA::KeyGenerator generator;
    QCA::PrivateKey privateKey = generator.createRSA(bits);
    emit privateKeyGenerated(privateKey.toPEM());
    QCA::PublicKey publicKey = privateKey.toPublicKey();
    emit publicKeyGenerated(publicKey.toPEM());
}

void LabCore3::generatePair(int bits) {
    emit workerGeneratePair(bits);
}

QString LabCore3::encrypt(QString textStr, QString keyStr) {
    QCA::PublicKey key = QCA::PublicKey::fromPEM(keyStr);
    QByteArray text = textStr.toUtf8();
    QByteArray text_enc = key.encrypt(text, QCA::EME_PKCS1_OAEP).toByteArray();
    return QCA::arrayToHex(text_enc);
}

QString LabCore3::decrypt(QString textStr, QString keyStr) {
    QCA::PrivateKey key = QCA::PrivateKey::fromPEM(keyStr);
    QByteArray text = QCA::hexToArray(textStr);
    QCA::SecureArray text_dec;
    bool success = key.decrypt(text, &text_dec, QCA::EME_PKCS1_OAEP);
    if (success) {
        return QString::fromUtf8(text_dec.toByteArray());
    } else {
        qDebug() << "Decryption Failure";
        return "";
    }
}
