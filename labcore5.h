#ifndef LABCORE5_H
#define LABCORE5_H

#include <QObject>

class LabCore5 : public QObject
{
    Q_OBJECT
public:
    explicit LabCore5(QObject *parent = nullptr);
    Q_INVOKABLE int generate(int len, int prev);

signals:
};

#endif // LABCORE5_H
