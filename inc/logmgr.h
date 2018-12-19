#ifndef LOGMGR_H
#define LOGMGR_H
#include <QVariant>
#include <QObject>

class LogMgr : public QObject
{
    Q_OBJECT
private:
    static QString logsFolderPath;
public:
    explicit LogMgr(QObject *parent = nullptr);

    static void debug(const std::string msg, const std::string& arg1);
    static void debug(const std::string msg, const QString& arg1);
    static void debug(const std::string msg, const char* arg1);
    static void debug(const std::string msg);
    static void error(const std::string msg);

    static void setLogsFolder(const QString& path);
};

#endif // LOGMGR_H
