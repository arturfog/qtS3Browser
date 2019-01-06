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
    // --------------------------------------------------------------------------
    QString getEmptyString() const {
        return "";
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE void selectLanguage(QString language);

signals:
    void languageChanged();

private:
    QTranslator *qtTranslator;
    QTranslator *myappTranslator;
};

#endif // TRANSLATIONSMGR_H
