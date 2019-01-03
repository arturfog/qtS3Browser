#include "inc/translationsmgr.h"

TranslationsMgr::TranslationsMgr()
{
    qtTranslator = new QTranslator(this);
    myappTranslator = new QTranslator(this);
}
