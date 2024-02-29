#ifndef QMLTOOLS_H
#define QMLTOOLS_H

#include <QObject>

class QMLTools : public QObject
{
    Q_OBJECT

public:

    explicit QMLTools(QObject* parent) : QObject(parent) {}

    Q_INVOKABLE QString removeAll(QString source, QString target) {
        int index;
        while (true) {
            index = source.indexOf(target);
            if (index > 0) source = source.remove(index, target.length());
            else break;
        }
        return source;
    }
};

#endif // QMLTOOLS_H
