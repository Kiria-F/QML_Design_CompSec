#include "labcore3.h"
#include <Qca-qt6/QtCrypto/QtCrypto>

LabCore3::LabCore3(QObject *parent) : QObject{parent} {
    worker.moveToThread(&workerThread);

    connect(this, &LabCore3::workerGeneratePair, &worker, &Worker::generatePair);
    connect(&worker, &Worker::publicKeyGenerated, this, &LabCore3::publicKeyGenerated);
    connect(&worker, &Worker::privateKeyGenerated, this, &LabCore3::privateKeyGenerated);
    connect(this, &LabCore3::workerEncrypt, &worker, &Worker::encrypt);
    connect(&worker, &Worker::encrypted, this, &LabCore3::encrypted);
    connect(this, &LabCore3::workerDecrypt, &worker, &Worker::decrypt);
    connect(&worker, &Worker::decrypted, this, &LabCore3::decrypted);

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

void Worker::encrypt(QString keyStr, QString textStr) {
    QCA::PublicKey key = QCA::PublicKey::fromPEM(keyStr);
    QByteArray text = textStr.toUtf8();
    QByteArray text_enc = key.encrypt(text, QCA::EME_PKCS1_OAEP).toByteArray();
    emit encrypted(QString::fromUtf8(text_enc));
}

void Worker::decrypt(QString keyStr, QString textStr) {
    QCA::PrivateKey key = QCA::PrivateKey::fromPEM(keyStr);
    QByteArray text = textStr.toUtf8();
    QCA::SecureArray text_dec;
    bool success = key.decrypt(text, &text_dec, QCA::EME_PKCS1_OAEP);
    if (success) {
        emit decrypted(QString::fromUtf8(text_dec.toByteArray()));
    }
}

void LabCore3::generatePair(int bits) {
    emit workerGeneratePair(bits);
}

void LabCore3::encrypt(QString text) {
    emit workerEncrypt(this->publicKey, text);
}

void LabCore3::decrypt(QString text) {
    emit workerEncrypt(this->privateKey, text);
}

void LabCore3::workerPrivateKeyGenerated(QString key) {
    emit privateKeyGenerated(key);
}

void LabCore3::workerPublicKeyGenerated(QString key) {
    emit publicKeyGenerated(key);
}

void LabCore3::workerEncrypted(QString text) {
    emit encrypted(text);
}

void LabCore3::workerDecrypted(QString text) {
    emit decrypted(text);
}
