#ifndef LOGMGR_H
#define LOGMGR_H
#include <QVariant>
#include <QObject>
#include <mutex>
#include <QFile>

class LogMgr : public QObject
{
    Q_OBJECT
private:
    static QString baseName;
    static const qint64 LOG_SIZE_LIMIT_MB = 5 * (1024 * 1024);
    static std::mutex mut;
    static QFile logfile;
public:
    explicit LogMgr(QObject *parent = nullptr);
    /**
     * @brief debug
     * @param msg
     * @param arg1
     */
    static void debug(const std::string &msg, const QString &arg1, const QString &arg2);
    /**
     * @brief debug
     * @param msg
     * @param arg1
     */
    static void debug(const std::string &msg, const std::string& arg1);
    /**
     * @brief debug
     * @param msg
     * @param arg1
     */
    static void debug(const std::string &msg, const QString& arg1);
    /**
     * @brief debug
     * @param msg
     * @param arg1
     */
    static void debug(const std::string &msg, const char* arg1);
    /**
     * @brief debug
     * @param msg
     */
    static void debug(const std::string &msg);
    /**
     * @brief error
     * @param msg
     */
    static void error(const std::string &msg);
    /**
     * @brief logsEnabled
     * @return
     */
    static bool logsEnabled();
    /**
     * @brief logsDir
     * @return
     */
    static QString logsDir();
    /**
     * @brief writeToFile
     * @param msg
     */
    static void writeToFile(const QString &msg);
    /**
     * @brief genLogFilename
     * @return
     */
    static QString genLogFilename(bool rotate = false);
    /**
     * @brief compareModifyTime
     * @return
     */
    static int compareModifyTime();
    /**
     * @brief openLog
     */
    static void openLog();
    /**
     * @brief closeLog
     */
    static void closeLog();
};

#endif // LOGMGR_H
