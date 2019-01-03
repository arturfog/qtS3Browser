#ifndef TRANSLATIONSMGR_H
#define TRANSLATIONSMGR_H

#include <QObject>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QObject>
#include <QDebug>

#include "inc/logmgr.h"

class TranslationsMgr : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString emptyString READ getEmptyString NOTIFY languageChanged)

public:
    TranslationsMgr();

    QString getEmptyString() {
        return "";
    }

    Q_INVOKABLE void selectLanguage(QString language) {
        LogMgr::debug(Q_FUNC_INFO, language);
        if(language == QString("pl")) {
            if(qtTranslator->load("qt_pl", QLibraryInfo::location(QLibraryInfo::TranslationsPath))) {
                qApp->installTranslator(qtTranslator);
            }

            if(myappTranslator->load("s3browser_pl", "translations")) {
                qApp->installTranslator(myappTranslator);
            }
        }

        if(language == QString("en")) {
            qApp->removeTranslator(qtTranslator);
            qApp->removeTranslator(myappTranslator);
        }

        emit languageChanged();
    }

signals:
    void languageChanged();

private:
    QTranslator *qtTranslator;
    QTranslator *myappTranslator;
};

#endif // TRANSLATIONSMGR_H
