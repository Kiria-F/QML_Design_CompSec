#include "labcore2.h"

LabCore2::LabCore2(QObject *parent)
    : QObject{parent}
{}

QString LabCore2::encrypt(QString mode, QString alignMode, QString initVectorStr, QString text, QString key) {
    auto preInitVector = initVectorStr.toLatin1();
    return "";
}
