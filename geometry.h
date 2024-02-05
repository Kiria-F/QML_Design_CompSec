#ifndef GEOMETRY_H
#define GEOMETRY_H

#include <QObject>

struct ArcConnectResult {
    Q_GADGET
    Q_PROPERTY(float dx MEMBER _dx)
    float _dx;
    Q_PROPERTY(float dy MEMBER _dy)
    float _dy;
    Q_PROPERTY(float ex MEMBER _ex)
    float _ex;
    Q_PROPERTY(float ey MEMBER _ey)
    float _ey;
public:
    ArcConnectResult();
    ArcConnectResult(float dx, float dy, float ex, float ey);
};

class Geometry : public QObject
{
    Q_OBJECT
public:
    explicit Geometry(QObject *parent = nullptr);
    Q_INVOKABLE ArcConnectResult arcConnect(float r, float ax, float ay, float bx, float by, float cx, float cy) const;
};

#endif // GEOMETRY_H
