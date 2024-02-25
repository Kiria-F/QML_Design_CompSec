#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSurfaceFormat>
#include <Qca-qt6/QtCrypto/QtCrypto>
#include "geometry.h"
#include "labcore1.h"
#include "labcore2.h"
#include "iofile.h"
#include "constants.h"

int main(int argc, char *argv[])
{
    QCA::Initializer qcaInit;
    QApplication app(argc, argv);

    QSurfaceFormat format;
    format.setSamples(8);
    QSurfaceFormat::setDefaultFormat(format);

    QQmlApplicationEngine engine;
    QMap<QString, QObject*> integrations {
        { "constants", new Constants(&app) },
        { "geometry", new Geometry(&app) },
        { "ioFile", new IOFile(&app) },
        { "ioFile", new IOFile(&app) },
        { "labCore1", new LabCore1(&app) },
        { "labCore2", new LabCore2(&app) }
    };
    for (auto integration = integrations.constKeyValueBegin(); integration != integrations.constKeyValueEnd(); ++integration) {
        engine.rootContext()->setContextProperty(integration->first, integration->second);
    }
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("ComputerSecurityLabs", "Main");

    return app.exec();
}
