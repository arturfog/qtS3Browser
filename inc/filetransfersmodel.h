#ifndef FILETRANSFERSMODEL_H
#define FILETRANSFERSMODEL_H

#include "inc/logmgr.h"
#include <QObject>
#include <QMap>

class FileTransfersModel : public QObject
{
    Q_OBJECT
public:
    enum class TransferMode { upload, download };
    explicit FileTransfersModel(QObject *parent = nullptr);
    // --------------------------------------------------------------------------
    Q_INVOKABLE int getTransfersNumQML() { return transfers.size(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QList<QString> getTransfersKeysQML() {return transfers.keys();}
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getTransferSrcPathQML(int idx) {
        return transfers.values().at(idx).at(0);
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getTransferDstPathQML(int idx) {
        return transfers.values().at(idx).at(1);
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE TransferMode getTransferModeQML(const QString &fileName) {
        return modes[fileName];
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getTransferIconQML(const QString &fileName) {
        if(modes[fileName] == TransferMode::download) {
            return "32_download_icon.png";
        }
        return "32_upload_icon.png";
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE void addTransferQML(const QString &fileName,
                                    const QString &src,
                                    const QString &dst)
    {
        LogMgr::debug(Q_FUNC_INFO, dst);

        if(!fileName.isEmpty() && !src.isEmpty())
        {
            if(!transfers.contains(fileName)) {
                QStringList list({src, dst});
                if(src.contains("s3://")) {
                    modes[fileName] = TransferMode::download;
                } else {
                    modes[fileName] = TransferMode::upload;
                }
                transfers[fileName] = list;
            }
        }
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE void removeTransferQML(const QString &fileName) {
        transfers.remove(fileName);
        modes.remove(fileName);
    }
private:
    QMap<QString, QStringList> transfers;
    QMap<QString, TransferMode> modes;
};

#endif // FILETRANSFERSMODEL_H
