#include "inc/logmgr.h"
#include <iostream>
#include <QDateTime>

LogMgr::LogMgr(QObject *parent) : QObject(parent) {}

QString LogMgr::logsFolderPath("/tmp");

void LogMgr::debug(const std::string msg, const std::string &arg1)
{
    const QString now = QDateTime::currentDateTime().toString();
    std::cout << "[DBG]"  << " " << now.toStdString() << " : " << msg  << " ('" << arg1  << "')" << std::endl;
}

void LogMgr::debug(const std::string msg, const QString &arg1)
{
    LogMgr::debug(msg, arg1.toStdString());
}

void LogMgr::debug(const std::string msg, const char *arg1)
{
    LogMgr::debug(msg, std::string(arg1));
}

void LogMgr::debug(const std::string msg)
{
    const QString now = QDateTime::currentDateTime().toString();
    std::cout << "[DBG]"  << " " << now.toStdString() << " : " << msg  << std::endl;
}

void LogMgr::error(const std::string msg)
{
    const QString now = QDateTime::currentDateTime().toString();
    std::cout << "[ERR]"  << " " << now.toStdString() << " : " << msg  << std::endl;
}

void LogMgr::setLogsFolder(const QString &path)
{
    LogMgr::logsFolderPath = path;
}
