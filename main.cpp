#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <Qca-qt6/QtCrypto/QtCrypto>
#include "geometry.h"
#include "labcore1.h"
#include "labcore2.h"
#include "constants.h"

int main(int argc, char *argv[])
{
    QCA::Initializer qcaInit;
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    Constants* constants = new Constants(&app);
    engine.rootContext()->setContextProperty("constants", constants);
    Geometry* geometry = new Geometry(&app);
    engine.rootContext()->setContextProperty("geometry", geometry);
    LabCore1* labCore1 = new LabCore1(&app);
    engine.rootContext()->setContextProperty("labCore1", labCore1);
    LabCore2* labCore2 = new LabCore2(&app);
    engine.rootContext()->setContextProperty("labCore2", labCore2);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("ComputerSecurityLabs", "Main");

    labCore2->test();

    return app.exec();
}
