#ifndef LABCORE6_H
#define LABCORE6_H

#include <QObject>
#include <QThread>

class ChainNode {
public:
    QByteArray nonce;
    QByteArray note;
    QByteArray prevHash;
    QByteArray hash;

    ChainNode(QString note, QByteArray prevHash);
    void recalcHash();
    bool validate(int targetPrefixLength);
    ChainNode& operator++();
};

class ChainNodeWrapper {
    Q_GADGET

public:
    Q_PROPERTY(QString nonce MEMBER nonce)
    QString nonce;
    Q_PROPERTY(QString note MEMBER note)
    QString note;
    Q_PROPERTY(QString prevHash MEMBER prevHash)
    QString prevHash;
    Q_PROPERTY(QString hash MEMBER hash)
    QString hash;

    ChainNodeWrapper(QString nonce, QString note, QString prevHash, QString hash);
    ChainNodeWrapper(ChainNode ChainNode);
};

class Miner : public QObject {
    Q_OBJECT

public:
    explicit Miner(QObject* parent = nullptr);

public slots:
    void mine(QString prevHash, QString note, int targetPrefixLength);

signals:
    void mined(ChainNodeWrapper);
};

class LabCore6 : public QObject {
    Q_OBJECT

    Miner miner;
    QThread minerThread;

public:
    explicit LabCore6(QObject *parent = nullptr);
    ~LabCore6();

signals:
    void mine(QString prevHash, QString note, int targetPrefixLength);
    void mined(ChainNodeWrapper);
};

#endif // LABCORE6_H
