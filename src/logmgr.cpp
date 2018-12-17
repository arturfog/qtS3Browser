#include "inc/logmgr.h"
#include <iostream>
#include <QDateTime>

LogMgr::LogMgr(QObject *parent) : QObject(parent)
{

}

void LogMgr::debug(const std::string msg, const std::string &arg1)
{
    QString now = QDateTime::currentDateTime().toString();
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
    QString now = QDateTime::currentDateTime().toString();
    std::cout << "[DBG]"  << " " << now.toStdString() << " : " << msg  << std::endl;
}

void LogMgr::error(const std::string msg)
{
    std::cout << "[ERR]" << " " << __TIMESTAMP__ << " : " << msg << std::endl;
}
