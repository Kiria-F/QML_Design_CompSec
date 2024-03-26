#include "labcore4.h"
#include <QDir>
#include <QFile>

LabCore4::LabCore4(QObject *parent)
    : QObject{parent}
{}

QList<QString> LabCore4::getAll() {
    QString dir("/etc/ssl/certs/");
    QList<QString> linkedCerts = QDir(dir).entryList().sliced(2);
    QList<QString> certs;
    for (QString& filename : linkedCerts) {
        QFile file(dir + filename);
        QString target = file.symLinkTarget();
        if (!target.isEmpty()) {
            certs.append(target.sliced(target.lastIndexOf('/') + 1).chopped(4));
        }
    }
    certs.removeDuplicates();
    certs.sort();
    return certs;
}
