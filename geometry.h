#ifndef GEOMETRY_H
#define GEOMETRY_H

#include <QObject>

struct ArcConnectResult {
    Q_GADGET
    Q_PROPERTY(float dx READ dx WRITE setDx)
    float _dx;
    Q_PROPERTY(float dy READ dy WRITE setDy)
    float _dy;
    Q_PROPERTY(float ex READ ex WRITE setEx)
    float _ex;
    Q_PROPERTY(float ey READ ey WRITE setEy)
    float _ey;
public:
    ArcConnectResult();
    ArcConnectResult(float dx, float dy, float ex, float ey);
    float dx() const;
    void setDx(float dx);
    float dy() const;
    void setDy(float dx);
    float ex() const;
    void setEx(float dx);
    float ey() const;
    void setEy(float dx);
};

class Geometry : public QObject
{
    Q_OBJECT
public:
    explicit Geometry(QObject *parent = nullptr);
    Q_INVOKABLE ArcConnectResult arcConnect(float r, float ax, float ay, float bx, float by, float cx, float cy) const;
};

#endif // GEOMETRY_H
