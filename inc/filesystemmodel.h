#ifndef FILESYSTEMMODEL_H
#define FILESYSTEMMODEL_H

#include <QObject>
#include <QFile>
#include <QDir>
#include <QDebug>
#include <QProcessEnvironment>

#include "inc/logmgr.h"

class FilesystemModel : public QObject
{
    Q_OBJECT
public:
    explicit FilesystemModel(QObject *parent = nullptr);
    // --------------------------------------------------------------------------
    Q_INVOKABLE void removeQML(const QString& path) {
        LogMgr::debug(Q_FUNC_INFO, path);
        QDir dir(path);
        if(dir.exists()) {
            dir.removeRecursively();
        } else {
            QFile file(path);
            file.remove();
        }
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE int createFolderQML(const QString& name, const QString& path) {
        LogMgr::debug(Q_FUNC_INFO, name);
        if(name.contains("/")) {
            // two "/" sign present. return error
            return -1;
        }

        QString tmpPath = path;
        tmpPath = tmpPath.replace("file://", "");
        QDir dir(tmpPath.append("/").append(name));
        if(!dir.exists()) {
            dir.mkdir(tmpPath);
            return true;
        }

        return -2;
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE bool fileExistsQML(const QString& path) {
        LogMgr::debug(Q_FUNC_INFO, path);
        QFile file(path);
        return file.exists();
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE bool isDirQML(const QString& path) {
        LogMgr::debug(Q_FUNC_INFO, path);
        QDir dir(path);
        return dir.exists();
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getOwner(const QString& path) {
        LogMgr::debug(Q_FUNC_INFO, path);
        QFileInfo fi(path);
        return fi.owner();
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getHomePath() const{
        LogMgr::debug(Q_FUNC_INFO);
#ifdef __linux__
    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
    if(env.contains("SNAP_ARCH")) {
        const QString user(env.value("USER"));
        if(!user.isEmpty()) {
            QString path("/home/");
            return path.append(user);
        }
    }
    return QDir::homePath();
#elif _WIN32
    return QString("/").append(QDir::homePath());
#else
    return QDir::homePath();
#endif
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString permissions(const QString& path) {
        LogMgr::debug(Q_FUNC_INFO, path);
        QFileInfo fi(path);
        QString executable = fi.isExecutable() ? "x" : "-";
        QString readable = fi.isReadable() ? "r" : "-";
        QString writeable = fi.isWritable() ? "w" : "-";

        return readable.append(writeable).append(executable);
    }
    // --------------------------------------------------------------------------
};

#endif // FILESYSTEMMODEL_H
