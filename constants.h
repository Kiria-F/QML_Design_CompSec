#ifndef CONSTANTS_H
#define CONSTANTS_H

#include <QObject>
#include <QColor>

class Constants : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QColor phantomTextColor MEMBER phantomTextColor CONSTANT)
    Q_PROPERTY(QColor weakTextColor MEMBER weakTextColor CONSTANT)
    Q_PROPERTY(QColor strongTextColor MEMBER strongTextColor CONSTANT)
    Q_PROPERTY(QString fontFamily MEMBER fontFamily CONSTANT)
    Q_PROPERTY(float radius MEMBER radius CONSTANT)
    Q_PROPERTY(float fontSize MEMBER fontSize CONSTANT)
public:
    explicit Constants(QObject* parent = nullptr) : QObject{parent} {}
    const QColor phantomTextColor = QColor(200, 200, 200);
    const QColor weakTextColor = QColor(170, 170, 170);
    const QColor strongTextColor = QColor(100, 100, 100);
    const QString fontFamily = "Source Code Pro";
    const float fontSize = 20;
    const float radius = 20;
};

#endif // CONSTANTS_H
