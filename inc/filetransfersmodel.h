#ifndef FILETRANSFERSMODEL_H
#define FILETRANSFERSMODEL_H

#include "inc/logmgr.h"
#include <QObject>
#include <QMap>

class FileTransfersModel : public QObject
{
    Q_OBJECT
public:
    explicit FileTransfersModel(QObject *parent = nullptr);
    // --------------------------------------------------------------------------
    Q_INVOKABLE int getTransfersNumQML() { return transfers.size(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QList<QString> getTransfersKeysQML() {return transfers.keys();}
    // --------------------------------------------------------------------------
    Q_INVOKABLE void addTransferQML(const QString &name, const QString &path)
    {
        LogMgr::debug(Q_FUNC_INFO, name);
        if(!name.isEmpty() && !path.isEmpty())
        {
            if(!transfers.contains(name)) {
                transfers[name] = path;
            }
        }
    }
private:
    QMap<QString, QString> transfers;
};

#endif // FILETRANSFERSMODEL_H
