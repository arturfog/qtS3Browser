/*
# Copyright (C) 2018  Artur Fogiel
# This file is part of qtS3Browser.
#
# qtS3Browser is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# qtS3Browser is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with qtS3Browser.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QFileSystemModel>
#include <QDateTime>
#include <QDesktopServices>
#include <QUrl>
#include <QObject>
#include <QQuickView>

#include "inc/s3client.h"
#include "inc/s3model.h"
#include "inc/iconprovider.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QCoreApplication::setOrganizationName("qtS3Browser");
    QCoreApplication::setApplicationName("qtS3Browser");
    QSettings settings;
    settings.setValue("StartPath", "s3://");
    settings.setValue("AccessKey", "123");
    settings.setValue("SecretKey", "abc");

    S3Model model;
    QQmlApplicationEngine engine;
    QQuickView view(&engine, nullptr);

    QQmlContext *ctxt = view.rootContext();
    ctxt->setContextProperty("s3Model", &model);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    engine.addImageProvider(QLatin1String("iconProvider"), new IconProvider());

    return app.exec();
}
