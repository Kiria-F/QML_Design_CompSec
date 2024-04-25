#ifndef LABCORE7_H
#define LABCORE7_H

#include <QObject>
#include <QRandomGenerator>
#include <Qca-qt6/QtCrypto/QtCrypto>

class LabCore7 : public QObject
{
    Q_OBJECT
    QRandomGenerator qRandomGenerator;

public:
    explicit LabCore7(QObject *parent = nullptr);
    Q_INVOKABLE QString getKey();
    Q_INVOKABLE QString encrypt(QString key, QString data);

signals:
};

#endif // LABCORE7_H
