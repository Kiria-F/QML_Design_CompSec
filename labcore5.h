#ifndef LABCORE5_H
#define LABCORE5_H

#include <QObject>

class LabCore5 : public QObject
{
    Q_OBJECT
    int timerRule = 285;
    int timerPrev = 1;
public:
    explicit LabCore5(QObject *parent = nullptr);
    Q_INVOKABLE int generate(int rule, int prev);

private slots:
    void timeout();

public slots:
    void updateRule(int rule);

signals:
    void addPoint(int x, int y);
};

#endif // LABCORE5_H
