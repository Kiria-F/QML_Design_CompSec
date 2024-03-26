#ifndef LABCORE4_H
#define LABCORE4_H

#include <QObject>

class LabCore4 : public QObject
{
    Q_OBJECT
public:
    explicit LabCore4(QObject *parent = nullptr);
    Q_INVOKABLE QList<QString> getAll();

signals:
};

#endif // LABCORE4_H
