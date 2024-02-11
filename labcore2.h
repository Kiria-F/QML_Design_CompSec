#ifndef LABCORE2_H
#define LABCORE2_H

#include <QObject>

class LabCore2 : public QObject
{
    Q_OBJECT
public:
    explicit LabCore2(QObject *parent = nullptr);
    Q_INVOKABLE QString encrypt(QString mode, QString alignMode, QString initVector, QString text, QString key);
signals:
};

#endif // LABCORE2_H
