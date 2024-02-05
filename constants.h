#ifndef CONSTANTS_H
#define CONSTANTS_H

#include <QObject>
#include <QColor>

class Constants : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QColor weakTextColor MEMBER weakTextColor CONSTANT)
public:
    explicit Constants(QObject* parent = nullptr) : QObject{parent} {}
    const QColor weakTextColor = QColor(200, 200, 200);
};

#endif // CONSTANTS_H
