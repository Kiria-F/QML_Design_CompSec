#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSurfaceFormat>
#include <Qca-qt6/QtCrypto/QtCrypto>
#include "geometry.h"
#include "labcore1.h"
#include "labcore2.h"
#include "labcore3.h"
#include "labcore4.h"
#include "labcore5.h"
#include "labcore6.h"
#include "labcore7.h"
#include "iofile.h"
#include "constants.h"
#include "qmltools.h"

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
        { "tools", new QMLTools(&app) },
        { "geometry", new Geometry(&app) },
        { "ioFile", new IOFile(&app) },
        { "ioFile", new IOFile(&app) },
        { "labCore1", new LabCore1(&app) },
        { "labCore2", new LabCore2(&app) },
        { "labCore3", new LabCore3(&app) },
        { "labCore4", new LabCore4(&app) },
        { "labCore5", new LabCore5(&app) },
        { "labCore6", new LabCore6(&app) },
        { "labCore7", new LabCore7(&app) }
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
