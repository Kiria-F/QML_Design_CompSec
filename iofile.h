#ifndef IOFILE_H
#define IOFILE_H

#include <QObject>
#include <QFile>
#include <QTextStream>

class IOFile : public QObject
{
    Q_OBJECT
public:
    explicit IOFile(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE QString read(QString path) {
        if (path.startsWith("file://")) path = path.sliced(7);
        QFile file(path);
        QString text;
        if (file.open(QIODevice::ReadOnly) ) {
            text = QTextStream (&file).readAll();
            file.close();
        }
        return text;
    }

    Q_INVOKABLE void write(QString path, QString text) {
        if (path.startsWith("file://")) path = path.sliced(7);
        QFile file(path);
        if (!file.open(QFile::WriteOnly | QFile::Truncate))
            return;
        QTextStream out(&file);
        out << text;
        file.close();
    }

signals:
};

#endif // IOFILE_H
