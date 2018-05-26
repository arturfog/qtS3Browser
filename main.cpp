#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QFileSystemModel>
#include <QDateTime>
#include <QDesktopServices>
#include <QUrl>
#include <QObject>
#include <QQuickView>

#include "s3client.h"
#include "s3model.h"
#include "iconprovider.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    S3Model model;

    QQmlApplicationEngine engine;
    QQuickView view(&engine, nullptr);

    QQmlContext *ctxt = view.rootContext();
    ctxt->setContextProperty("s3Model", &model);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    engine.addImageProvider(QLatin1String("iconProvider"), new IconProvider());

    return app.exec();
}
