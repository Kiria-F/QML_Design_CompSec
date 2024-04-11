#include "labcore5.h"
#include <QDebug>
#include <QTimer>
#include <QRandomGenerator>

LabCore5::LabCore5(QObject *parent)
    : QObject{parent}
{
    QTimer* timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, &LabCore5::timeout);
    timer->start(1);
}

long LabCore5::generate(long rule, long prev) {
    long rBit = 0;
    long next = prev >> 1;
    long lBitIndex = 0;
    while (rule > 1) {
        if (rule & 1) {
            rBit ^= prev & 1;
        }
        rule >>= 1;
        prev >>= 1;
        ++lBitIndex;
    }
    return next | rBit << --lBitIndex;
}

void LabCore5::updateRule(int rule) {
    timerRule = rule;
    timerPrev = 1;
}

void LabCore5::timeout() {
    long x = generate(timerRule, timerPrev);
    // long x = generate(140563309249406177, timerPrev);
    // long x = (generator.generate() % 256 + generator.generate() % 256) / 2;
    if (x == 1) {
        emit loopLengthFound(loopLength);
        loopLength = 1;
    } else {
        ++loopLength;
    }

    long y = generate(timerRule, x);
    // long y = generate(140563309249406177, x);
    // long y = (generator.generate() % 256 + generator.generate() % 256) / 2;
    if (y == 1) {
        emit loopLengthFound(loopLength);
        loopLength = 1;
    } else {
        ++loopLength;
    }

    timerPrev = y;
    emit addPoint(x % 256, y % 256);
    // qDebug() << x << y;
}
