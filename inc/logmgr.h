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
    static constexpr const qint64 LOG_SIZE_LIMIT_MB = 5 * (1024 * 1024);
    static std::mutex mut;
    static QFile logfile;

    enum class LOG_LEVEL {
        DEBUG,
        INFO,
        TRACE,
        ERR
    };

    static void log(const LOG_LEVEL level, const std::string& msg);

    template <typename T>
    static void log(const LOG_LEVEL level, const std::string &msg, T const& x);

    static const std::string LvlToString(LOG_LEVEL lvl);
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

    // ERROR
    static void error(const std::string &msg);

    template <typename T>
    static void error(const std::string &msg, T const& x);

    // TRACE
    static void trace(const std::string &msg);

    template <typename T>
    static void trace(const std::string &msg, T const& x);

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
