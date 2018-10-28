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
    Q_INVOKABLE bool createFolderQML(const QString& name, const QString& path) {
        QString tmpPath = path;
        tmpPath = tmpPath.replace("file://", "");
        QDir dir(tmpPath.append("/").append(name));
        if(!dir.exists()) {
            dir.mkdir(tmpPath);
            return true;
        }

        return false;
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
};

#endif // FILESYSTEMMODEL_H
