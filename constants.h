#ifndef CONSTANTS_H
#define CONSTANTS_H

#include <QObject>
#include <QColor>

class Constants : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QColor weakTextColor MEMBER weakTextColor CONSTANT)
    Q_PROPERTY(QColor strongTextColor MEMBER strongTextColor CONSTANT)
public:
    explicit Constants(QObject* parent = nullptr) : QObject{parent} {}
    const QColor weakTextColor = QColor(170, 170, 170);
    const QColor strongTextColor = QColor(100, 100, 100);
};

#endif // CONSTANTS_H
