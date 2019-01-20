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
    Q_INVOKABLE void removeQML(const QString& path);
    // --------------------------------------------------------------------------
    Q_INVOKABLE int createFolderQML(const QString& name, const QString& path);
    // --------------------------------------------------------------------------
    Q_INVOKABLE bool fileExistsQML(const QString& path) const;
    // --------------------------------------------------------------------------
    Q_INVOKABLE bool isDirQML(const QString& path) const;
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getOwner(const QString& path) const;
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getHomePath() const;
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString permissions(const QString& path) const;
    // --------------------------------------------------------------------------
    Q_INVOKABLE long int getFolderSizeInKB(const QString& path) const;
    // --------------------------------------------------------------------------
    Q_INVOKABLE long int getFileSizeInKB(const QString& path) const;
};

#endif // FILESYSTEMMODEL_H
