#ifndef LABCORE6_H
#define LABCORE6_H

#include <QObject>

class RawChainNode {
public:
    QByteArray nonce;
    QByteArray note;
    QByteArray prevHash;
    QByteArray hash;

    RawChainNode(QString note, QByteArray prevHash);
    void recalcHash();
    RawChainNode& operator++();
};

class ChainNode {
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

    ChainNode(QString nonce, QString note, QString prevHash, QString hash);
    ChainNode(RawChainNode rawChainNode);
};

class LabCore6 : public QObject
{
    Q_OBJECT
public:
    explicit LabCore6(QObject *parent = nullptr);

public slots:
    void mine(QString prevHash, QString note, int targetPrefixLength);

signals:
};

#endif // LABCORE6_H
