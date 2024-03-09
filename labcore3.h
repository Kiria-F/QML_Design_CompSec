#ifndef LABCORE3_H
#define LABCORE3_H

#include <QObject>
#include <QRunnable>
#include <QThread>

class LabCore3;

class Worker : public QObject {
    Q_OBJECT

public:
    explicit Worker(QObject* parent = nullptr) : QObject(parent) {}

public slots:
    void generatePair(int bits);
    void encrypt(QString publicKey, QString text);
    void decrypt(QString privateKey, QString text);

signals:
    void privateKeyGenerated(QString key);
    void publicKeyGenerated(QString key);
    void encrypted(QString text);
    void decrypted(QString text);
};

class LabCore3 : public QObject {
    Q_OBJECT
    friend Worker;
    Worker worker;
    QThread workerThread;

public:
    QString privateKey;
    QString publicKey;

    explicit LabCore3(QObject *parent = nullptr);
    ~LabCore3();

public slots:
    void generatePair(int bits);
    void encrypt(QString text);
    void decrypt(QString text);

private slots:
    void workerPrivateKeyGenerated(QString key);
    void workerPublicKeyGenerated(QString key);
    void workerEncrypted(QString text);
    void workerDecrypted(QString text);

signals:
    void privateKeyGenerated(QString key);
    void publicKeyGenerated(QString key);
    void encrypted(QString text);
    void decrypted(QString text);

    void workerGeneratePair(int bits);
    void workerEncrypt(QString publicKey, QString text);
    void workerDecrypt(QString privateKey, QString text);
};

#endif // LABCORE3_H
