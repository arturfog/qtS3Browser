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
    Q_ENUMS(TransferMode)

    explicit FileTransfersModel(QObject *parent = nullptr);
    // --------------------------------------------------------------------------
    Q_INVOKABLE int getTransfersNumQML() { return transfers.size(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QList<QString> getTransfersKeysQML() {return transfers.keys();}
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getTransferSrcPathQML(int idx) const {
        return transfers.values().at(idx).at(0);
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getTransferDstPathQML(int idx) const {
        return transfers.values().at(idx).at(1);
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE TransferMode getTransferModeQML(int idx) const {
        return modes.values().at(idx);
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
        LogMgr::debug(Q_FUNC_INFO, src, dst);

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
        LogMgr::debug(Q_FUNC_INFO, fileName);
        transfers.remove(fileName);
        modes.remove(fileName);
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE void removeTransferQML(const int idx) {
        LogMgr::debug(Q_FUNC_INFO);
        QString fileName(transfers.keys().at(idx));
        transfers.remove(fileName);
        modes.remove(fileName);
    }
    // --------------------------------------------------------------------------
    void addTransferProgress(const QString key,
                             const unsigned long current,
                             const unsigned long total) {
        transfersProgress[key] = { current, total };
    }
    // --------------------------------------------------------------------------
    void clearTranferProgress() {
        transfersProgress.clear();
    }
private:
    QMap<QString, QStringList> transfers;
    QMap<QString, TransferMode> modes;
    QMap<QString, QList<unsigned long>> transfersProgress;
};

#endif // FILETRANSFERSMODEL_H
