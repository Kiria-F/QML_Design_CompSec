#ifndef LABCORE5_H
#define LABCORE5_H

#include <QObject>
#include <QRandomGenerator64>

class LabCore5 : public QObject
{
    Q_OBJECT
    long timerRule = 285;
    long timerPrev = 1;
    long loopLength = 1;
    QRandomGenerator64 generator;
public:
    explicit LabCore5(QObject *parent = nullptr);
    Q_INVOKABLE long generate(long rule, long prev);

private slots:
    void timeout();

public slots:
    void updateRule(int rule);

signals:
    void addPoint(int x, int y);
    void loopLengthFound(long length);
};

#endif // LABCORE5_H
