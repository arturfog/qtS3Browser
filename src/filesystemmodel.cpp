#include "inc/filesystemmodel.h"

FilesystemModel::FilesystemModel(QObject *parent) : QObject(parent) {}
// --------------------------------------------------------------------------
Q_INVOKABLE void FilesystemModel::removeQML(const QString& path) {
    LogMgr::debug(Q_FUNC_INFO, path);

    if(!path.isEmpty()) {
        QDir dir(path);
        if(dir.exists()) {
            dir.removeRecursively();
        } else {
            QFile file(path);
            if(file.exists()) {
                file.remove();
            }
        }
    }
}
// --------------------------------------------------------------------------
Q_INVOKABLE int FilesystemModel::createFolderQML(const QString& name, const QString& path) {
    LogMgr::debug(Q_FUNC_INFO, name);
    if(name.contains("/")) {
        // two "/" sign present. return error
        return -1;
    }

    if(!path.isEmpty() && !name.isEmpty()) {
        QString tmpPath(path);
        tmpPath = tmpPath.replace("file://", "");
        QDir dir(tmpPath.append("/").append(name));
        if(!dir.exists() && !tmpPath.isEmpty()) {
            dir.mkdir(tmpPath);
            return true;
        }
    }

    return -2;
}
// --------------------------------------------------------------------------
Q_INVOKABLE bool FilesystemModel::fileExistsQML(const QString& path) const {
    LogMgr::debug(Q_FUNC_INFO, path);

    if(!path.isEmpty()) {
        QFile file(path);
        return file.exists();
    }
    return false;
}
// --------------------------------------------------------------------------
Q_INVOKABLE QString FilesystemModel::getHomePath() const {
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
Q_INVOKABLE QString FilesystemModel::permissions(const QString& path) const {
    LogMgr::debug(Q_FUNC_INFO, path);
    const QFileInfo fi(path);
    QString executable = fi.isExecutable() ? "x" : "-";
    QString readable = fi.isReadable() ? "r" : "-";
    QString writeable = fi.isWritable() ? "w" : "-";

    return readable.append(writeable).append(executable);
}
// --------------------------------------------------------------------------
long FilesystemModel::getFolderSizeInKB(const QString &path) const
{
    LogMgr::debug(Q_FUNC_INFO, path);
    qint64 size = 0;

    if(!path.isEmpty()) {
        QDir dir(path);
        QDir::Filters fileFilters = QDir::Files|QDir::System|QDir::Hidden;
            for(QString filePath : dir.entryList(fileFilters)) {
                QFileInfo fi(dir, filePath);
                size+= fi.size();
            }
    }

    return size / 1024;
}
// --------------------------------------------------------------------------
long FilesystemModel::getFileSizeInKB(const QString &path) const
{
    LogMgr::debug(Q_FUNC_INFO, path);
    qint64 size = 0;

    if(!path.isEmpty()) {
        QFile file(path);
        size = file.size();
    }

    return size / 1024;
}
// --------------------------------------------------------------------------
Q_INVOKABLE bool FilesystemModel::isDirQML(const QString& path) const {
    LogMgr::debug(Q_FUNC_INFO, path);

    if(!path.isEmpty()) {
        QDir dir(path);
        return dir.exists();
    }
    return false;
}
// --------------------------------------------------------------------------
Q_INVOKABLE QString FilesystemModel::getOwner(const QString& path) const {
    LogMgr::debug(Q_FUNC_INFO, path);
    QFileInfo fi(path);
    return fi.owner();
}
