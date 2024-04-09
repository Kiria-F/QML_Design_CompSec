#include "labcore5.h"

LabCore5::LabCore5(QObject *parent)
    : QObject{parent}
{}

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
