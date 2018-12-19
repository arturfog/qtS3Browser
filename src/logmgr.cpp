#include "inc/logmgr.h"
#include <iostream>
#include <QDateTime>
#include <QSettings>
#include <QFile>
#include <QTextStream>

LogMgr::LogMgr(QObject *parent) : QObject(parent) {}
// --------------------------------------------------------------------------
void LogMgr::debug(const std::string msg, const std::string &arg1)
{
    const QString now = QDateTime::currentDateTime().toString();
    std::cout << "[DBG]"  << " " << now.toStdString() << " : " << msg  << " ('" << arg1  << "')" << std::endl;
}
// --------------------------------------------------------------------------
void LogMgr::debug(const std::string msg, const QString &arg1)
{
    LogMgr::debug(msg, arg1.toStdString());
}
// --------------------------------------------------------------------------
void LogMgr::debug(const std::string msg, const char *arg1)
{
    LogMgr::debug(msg, std::string(arg1));
}
// --------------------------------------------------------------------------
void LogMgr::debug(const std::string msg)
{
    const QString now = QDateTime::currentDateTime().toString();
    std::cout << "[DBG]"  << " " << now.toStdString() << " : " << msg  << std::endl;
}
// --------------------------------------------------------------------------
void LogMgr::error(const std::string msg)
{
    const QString now = QDateTime::currentDateTime().toString();
    std::cout << "[ERR]"  << " " << now.toStdString() << " : " << msg  << std::endl;
}
// --------------------------------------------------------------------------
bool LogMgr::logsEnabled()
{
    const QSettings settings;
    return settings.value("LogsEnabled").toBool();
}
// --------------------------------------------------------------------------
QString LogMgr::logsDir()
{
    const QSettings settings;
    return settings.value("LogsDir").toString();
}
// --------------------------------------------------------------------------
void LogMgr::writeToFile(const QString& msg)
{
    if(logsEnabled()) {
        QFile logfile(logsDir());
        if(logfile.open(QIODevice::WriteOnly)) {
            QTextStream stream( &logfile );
            stream << msg << endl;
        }
    }
}
