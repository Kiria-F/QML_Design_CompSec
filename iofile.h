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
        QFile file(path);
        QString fileContent;
        if (file.open(QIODevice::ReadOnly) ) {
            QString line;
            QTextStream t(&file);
            do {
                line = t.readLine();
                fileContent += line;
            } while (!line.isNull());
            file.close();
        }
        return fileContent;
    }

    Q_INVOKABLE void write(QString path, QString text) {
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
