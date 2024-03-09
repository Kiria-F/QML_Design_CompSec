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
    void encrypt(QString text, QString publicKey);
    void decrypt(QString text, QString privateKey);

signals:
    void privateKeyGenerated(QString key);
    void publicKeyGenerated(QString key);
    void encrypted(QString text);
    void decrypted(QString text);
};

class LabCore3 : public QObject {
    Q_OBJECT
    Worker worker;
    QThread workerThread;

public:
    explicit LabCore3(QObject *parent = nullptr);
    ~LabCore3();

public slots:
    void generatePair(int bits);
    void encrypt(QString text, QString publicKey);
    void decrypt(QString text, QString privateKey);

signals:
    void privateKeyGenerated(QString key);
    void publicKeyGenerated(QString key);
    void encrypted(QString text);
    void decrypted(QString text);

    void workerGeneratePair(int bits);
    void workerEncrypt(QString text, QString publicKey);
    void workerDecrypt(QString text, QString privateKey);
};

#endif // LABCORE3_H
