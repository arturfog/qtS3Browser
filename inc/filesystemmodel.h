#ifndef FILESYSTEMMODEL_H
#define FILESYSTEMMODEL_H

#include <QObject>
#include <QFile>
#include <QDir>
#include <QDebug>
class FilesystemModel : public QObject
{
    Q_OBJECT
public:
    explicit FilesystemModel(QObject *parent = nullptr);
    // --------------------------------------------------------------------------
    Q_INVOKABLE void removeQML(const QString& path) {
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
        QFile file(path);
        return file.exists();
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE bool isDirQML(const QString& path) {
        QDir dir(path);
        return dir.exists();
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getOwner(const QString& path) {
        QFileInfo fi(path);
        return fi.owner();
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getHomePath() {
        return QDir::homePath();
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString permissions(const QString& path) {
        QFileInfo fi(path);
        QString executable = fi.isExecutable() ? "x" : "-";
        QString readable = fi.isReadable() ? "r" : "-";
        QString writeable = fi.isWritable() ? "w" : "-";

        return readable.append(writeable).append(executable);
    }
    // --------------------------------------------------------------------------
};

#endif // FILESYSTEMMODEL_H
