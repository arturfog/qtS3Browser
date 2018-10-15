#ifndef FILESYSTEMMODEL_H
#define FILESYSTEMMODEL_H

#include <QObject>
#include <QFile>
#include <QDebug>
class FilesystemModel : public QObject
{
    Q_OBJECT
public:
    explicit FilesystemModel(QObject *parent = nullptr);
    // --------------------------------------------------------------------------
    Q_INVOKABLE void removeQML(const QString& filePath) {
        QFile file(filePath);
        qDebug() << "canRemove: " << file.exists() << " " << file.fileName();
        file.remove();
    }
    // --------------------------------------------------------------------------
};

#endif // FILESYSTEMMODEL_H
