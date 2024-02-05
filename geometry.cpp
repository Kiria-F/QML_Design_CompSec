#include "geometry.h"

ArcConnectResult::ArcConnectResult() {}

ArcConnectResult::ArcConnectResult(float dx, float dy, float ex, float ey) : _dx(dx), _dy(dy), _ex(ex), _ey(ey) {}

Geometry::Geometry(QObject *parent)
    : QObject{parent}
{}

ArcConnectResult Geometry::arcConnect(float r, float ax, float ay, float bx, float by, float cx, float cy) const {
    float v1x = ax - bx;
    float v1y = ay - by;
    float v2x = cx - bx;
    float v2y = cy - by;
    float cosa = (v1x * v2x + v1y * v2y) / (sqrt(v1x * v1x + v1y * v1y) * sqrt(v2x * v2x + v2y * v2y));
    float fb = r / tan(acos(cosa) / 2);
    float ab = sqrt((bx - ax) * (bx - ax) + (by - ay) * (by - ay));
    float cb = sqrt((cx - bx) * (cx - bx) + (cy - by) * (cy - by));
    float dx = (bx - ax) * (1 - fb / ab) + ax;
    float dy = (by - ay) * (1 - fb / ab) + ay;
    float ex = (bx - cx) * (1 - fb / cb) + cx;
    float ey = (by - cy) * (1 - fb / cb) + cy;
    return { dx, dy, ex, ey };
}
