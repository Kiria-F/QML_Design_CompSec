#include "labcore4.h"
#include <QDir>
#include <QFile>

LabCore4::LabCore4(QObject *parent)
    : QObject{parent}
{}

QList<QString> LabCore4::getAll() {
    certsMap.clear();
    QString dir("/etc/ssl/certs/");
    QList<QString> linkedCerts = QDir(dir).entryList().sliced(2);
    QList<QString> certs;
    for (QString& filename : linkedCerts) {
        QFile file(dir + filename);
        QString target = file.symLinkTarget();
        if (!target.isEmpty()) {
            QString targetFilename = target.sliced(target.lastIndexOf('/') + 1).chopped(4);
            certs.append(targetFilename);
            certsMap[targetFilename] = target;
        }
    }
    certs.removeDuplicates();
    certs.sort();
    return certs;
}

QString LabCore4::getOne(QString certName) {
    QFile file(certsMap[certName]);
    if (file.open(QIODeviceBase::ReadOnly | QIODeviceBase::Text)) {
        return file.readAll();
    }
    return "Failed to read this certificate";
}
