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
    Q_INVOKABLE bool createFolderQML(const QString &path) {
        QDir dir(path);
        if(!dir.exists()) {
            dir.mkdir(path);
            return true;
        }

        return false;
    }
    // --------------------------------------------------------------------------
};

#endif // FILESYSTEMMODEL_H
