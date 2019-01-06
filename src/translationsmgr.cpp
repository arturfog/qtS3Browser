#include "inc/translationsmgr.h"

TranslationsMgr::TranslationsMgr()
{
    qtTranslator = new QTranslator(this);
    myappTranslator = new QTranslator(this);
}
// --------------------------------------------------------------------------
Q_INVOKABLE void TranslationsMgr::selectLanguage(QString language) {
    LogMgr::debug(Q_FUNC_INFO, language);
    if(language == QString("pl")) {
        if(qtTranslator->load("qt_pl", QLibraryInfo::location(QLibraryInfo::TranslationsPath))) {
            qApp->installTranslator(qtTranslator);
        }

        if(myappTranslator->load("s3browser_pl", ":/translations/")) {
            qApp->installTranslator(myappTranslator);
        } else {
            qDebug("false");
        }
    }

    if(language == QString("en")) {
        qApp->removeTranslator(qtTranslator);
        qApp->removeTranslator(myappTranslator);
    }

    emit languageChanged();
}
