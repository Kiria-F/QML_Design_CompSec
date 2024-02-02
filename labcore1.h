#ifndef LABCORE1_H
#define LABCORE1_H

#include <QObject>

class LabCore1 : public QObject
{
    Q_OBJECT
public:
    explicit LabCore1(QObject *parent = nullptr);

signals:
};

#endif // LABCORE1_H
