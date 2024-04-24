#ifndef LABCORE6_H
#define LABCORE6_H

#include <QObject>

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

class LabCore6 : public QObject
{
    Q_OBJECT
public:
    explicit LabCore6(QObject *parent = nullptr);

public slots:
    void mine(QString prevHash, QString note, int targetPrefixLength);

signals:
    void mined(ChainNodeWrapper);
};

#endif // LABCORE6_H
