#ifndef LABCORE3_H
#define LABCORE3_H

#include <QObject>
#include <QRunnable>
#include <QThread>

// for cert in $(ls -h /etc/ssl/certs); do openssl verify /etc/ssl/certs/$cert; done

class LabCore3;

class Worker : public QObject {
    Q_OBJECT

public:
    explicit Worker(QObject* parent = nullptr) : QObject(parent) {}

public slots:
    void generatePair(int bits);

signals:
    void privateKeyGenerated(QString key);
    void publicKeyGenerated(QString key);
};

class LabCore3 : public QObject {
    Q_OBJECT
    Worker worker;
    QThread workerThread;

public:
    explicit LabCore3(QObject *parent = nullptr);
    ~LabCore3();

    Q_INVOKABLE QString encrypt(QString text, QString publicKey);
    Q_INVOKABLE QString decrypt(QString text, QString privateKey);

public slots:
    void generatePair(int bits);

signals:
    void privateKeyGenerated(QString key);
    void publicKeyGenerated(QString key);
    void workerGeneratePair(int bits);
};

#endif // LABCORE3_H
