#ifndef LABCORE2_H
#define LABCORE2_H

#include <QObject>

class LabCore2 : public QObject
{
    Q_OBJECT
public:
    explicit LabCore2(QObject *parent = nullptr);
    Q_INVOKABLE QString process(QString type, QString mode, QString paddingMode, QString initVector, QString key, QString text, QString direction);
    Q_INVOKABLE QString test();
signals:
};

#endif // LABCORE2_H
