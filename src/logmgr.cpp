#include "inc/logmgr.h"
#include <iostream>
#include <QDateTime>
#include <QSettings>
#include <QFile>
#include <QTextStream>
#include <QFileInfo>
#include <QDebug>

QString LogMgr::baseName("qts3browser.log");
std::mutex LogMgr::mut;
QFile LogMgr::logfile;


const std::string LogMgr::LvlToString(LOG_LEVEL lvl)
{
    switch (lvl)
    {
    case LOG_LEVEL::DEBUG: return "[DBG]";
    case LOG_LEVEL::INFO:  return "[INFO]";
    case LOG_LEVEL::TRACE: return "[TRACE]";
    case LOG_LEVEL::ERROR: return "[ERR]";
    }

    return "";
}

LogMgr::LogMgr(QObject *parent) : QObject(parent) {}
// --------------------------------------------------------------------------
void LogMgr::log(const LogMgr::LOG_LEVEL level, const std::string &msg)
{
    const QString now = QDateTime::currentDateTime().toString();
    QString log(LvlToString(level).c_str());
    log.append(now).append(" : ").append(msg.c_str());

    writeToFile(log);
}
// --------------------------------------------------------------------------
void LogMgr::debug(const std::string &msg, const std::string &arg1)
{
    log(LOG_LEVEL::DEBUG, msg, arg1);
}
// --------------------------------------------------------------------------
void LogMgr::debug(const std::string &msg, const QString &arg1)
{
    LogMgr::debug(msg, arg1.toStdString());
}
// --------------------------------------------------------------------------
void LogMgr::debug(const std::string &msg, const QString &arg1, const QString &arg2)
{
    QString tmpArg(arg1);
    tmpArg.append(" ").append(arg2);
    LogMgr::debug(msg, tmpArg.toStdString());
}
// --------------------------------------------------------------------------
void LogMgr::debug(const std::string &msg, const char *arg1)
{
    if(arg1 != nullptr) {
        LogMgr::debug(msg, std::string(arg1));
    } else {
        LogMgr::debug(msg, "nullptr");
    }
}
// --------------------------------------------------------------------------
void LogMgr::debug(const std::string &msg)
{
    log(LOG_LEVEL::DEBUG, msg);
}
// --------------------------------------------------------------------------
void LogMgr::error(const std::string &msg)
{
    log(LOG_LEVEL::ERROR, msg);
}
// --------------------------------------------------------------------------
void LogMgr::trace(const std::string &msg)
{
    log(LOG_LEVEL::TRACE, msg);
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
    return settings.value("LogsDir").toString().replace("file://","");
}
// --------------------------------------------------------------------------
void LogMgr::writeToFile(const QString& msg)
{
    if(logsEnabled()) {
        std::lock_guard<std::mutex> lock(mut);
        // log is opened when app is started and logs
        // are enabled in settings, if logs were enabled
        // later, log file has to be opened
        if(!logfile.isOpen()) {
            openLog();
        } else if(logfile.size() >= LOG_SIZE_LIMIT_MB) {
            closeLog();
            openLog();
        }

        QTextStream stream( &logfile );
        stream << msg << endl;
    }
}
// --------------------------------------------------------------------------
QString LogMgr::genLogFilename(bool rotate)
{
    const QString fullPath(logsDir().append("/").append(baseName));
    for(int i = 0; i < 8; i++)
    {
        QString tmpFullPath(fullPath);
        const QString pathWithNumber(tmpFullPath.append(QString::number(i)));
        const QFile logfile(pathWithNumber);
        if(!logfile.exists())
        {
            return pathWithNumber;
        }
        else if (logfile.size() < LOG_SIZE_LIMIT_MB || rotate)
        {
            if(rotate) {
                const int rotatedNum = compareModifyTime();

                QString tmpFullPath(fullPath);
                const QString pathWithNumber(tmpFullPath.append(QString::number(rotatedNum)));
                return pathWithNumber;
            }
            return pathWithNumber;
        }
    }
    // all log files are full. rotate logs.
    return genLogFilename(true);
}
// --------------------------------------------------------------------------
int LogMgr::compareModifyTime()
{
    const QString fullPath(logsDir().append("/").append(baseName));
    for(int i = 0; i < 8; i++)
    {
        QString tmpPath(fullPath);
        const int current = i % 8;
        const int next = (i + 1) % 8;

        const QString currPathWithNumber(tmpPath.append(QString::number(current)));
        const QFileInfo currInfo(currPathWithNumber);
        const qint64 currTime = currInfo.lastModified().toSecsSinceEpoch();

        tmpPath = fullPath;
        const QString nextPathWithNumber(tmpPath.append(QString::number(next)));
        const QFileInfo nextInfo(nextPathWithNumber);
        const qint64 nextTime = nextInfo.lastModified().toSecsSinceEpoch();

        if(currTime > nextTime) {
            return next;
        }
    }

    return 0;
}
// --------------------------------------------------------------------------
void LogMgr::openLog()
{
    if(logsEnabled()) {
        logfile.setFileName(genLogFilename());
        if(logfile.size() >= LOG_SIZE_LIMIT_MB) {
            logfile.remove();
            logfile.open(QIODevice::WriteOnly | QIODevice::Append);
        } else {
            logfile.open(QIODevice::WriteOnly | QIODevice::Append);
        }
    }
}
// --------------------------------------------------------------------------
void LogMgr::closeLog()
{
    logfile.flush();
    logfile.close();
}
// --------------------------------------------------------------------------
template<typename T>
void LogMgr::trace(const std::string &msg, const T &x)
{
    log(LOG_LEVEL::TRACE, msg, x);
}
// --------------------------------------------------------------------------
template<typename T>
void LogMgr::error(const std::string &msg, const T &x)
{
   log(LOG_LEVEL::ERROR, msg, x);
}
// --------------------------------------------------------------------------
template<typename T>
void LogMgr::log(const LogMgr::LOG_LEVEL level, const std::string &msg, const T &x)
{
    const QString now = QDateTime::currentDateTime().toString();
    QString log(LvlToString(level).c_str());
    log.append(now).append(" : ").append(msg.c_str());
    log.append(" (").append(x.c_str()).append(") ");

    std::cout << log.toStdString() << std::endl;
    writeToFile(log);
}
