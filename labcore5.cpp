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

int LabCore5::generate(int rule, int prev) {
    int rBit = 0;
    int next = prev >> 1;
    int lBitIndex = 0;
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
    int x = generate(timerRule, timerPrev);
    int y = generate(timerRule, x);
    // int x = rand() % 256;
    // int y = rand() % 256;
    timerPrev = y;
    emit addPoint(x, y);
}
