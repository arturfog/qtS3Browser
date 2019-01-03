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
    Q_INVOKABLE inline int getTransfersNumQML() const { return transfers.size(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE inline QList<QString> getTransfersKeysQML() const { return transfers.keys(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getTransferSrcPathQML(const int idx) const {
        if(transfers.size() > 0 && idx < transfers.size() && idx >= 0) {
            return transfers.values().at(idx).at(0);
        }
        return "";
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getTransferDstPathQML(const int idx) const {
        if(transfers.size() > 0 && idx < transfers.size() && idx >= 0) {
            return transfers.values().at(idx).at(1);
        }
        return "";
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE TransferMode getTransferModeQML(const int idx) const {
        if(modes.size() > 0 && idx < modes.size() && idx >= 0) {
            return modes.values().at(idx);
        }
        return TransferMode::download;
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getTransferIconQML(const QString &fileName) const {
        if(modes[fileName] == TransferMode::download) {
            return "32_download_icon.png";
        }
        return "32_upload_icon.png";
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE void addTransferToQueueQML(const QString &fileName,
                                    const QString &src,
                                    const QString &dst)
    {
        LogMgr::debug(Q_FUNC_INFO, src, dst);
        if(!fileName.isEmpty() && !src.isEmpty() && !dst.isEmpty())
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
        if(!fileName.isEmpty() && transfers.contains(fileName)) {
            transfers.remove(fileName);
            modes.remove(fileName);
        }
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE void removeTransferQML(const int idx) {
        LogMgr::debug(Q_FUNC_INFO);

        if(transfers.size() > 0 && idx < transfers.size() && idx >= 0) {
            QString fileName(transfers.keys().at(idx));
            transfers.remove(fileName);
            modes.remove(fileName);
        }
    }
    // --------------------------------------------------------------------------
    void addTransferProgress(const QString key,
                             const unsigned long current,
                             const unsigned long total) {
        //LogMgr::debug(Q_FUNC_INFO, key);
        std::lock_guard<std::mutex> lock(mut);
        if(!key.isEmpty()) {
            if(!transfersProgress.contains(key)) {
                transfersProgress.insert(key, { current, total });
            } else {
                transfersProgress[key] = { current, total };
            }
        }
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE inline int getTransferProgressNum() const {
        return transfersProgress.size();
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE unsigned long getTransfersCopiedBytes(const QString& key) const {
        //LogMgr::debug(Q_FUNC_INFO);
        if(!key.isEmpty() && transfersProgress.contains(key)) {
            return transfersProgress[key].first();
        }
        return 0;
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE unsigned long getTransfersTotalBytes(const QString& key) const {
        //LogMgr::debug(Q_FUNC_INFO);
        if(!key.isEmpty() && transfersProgress.contains(key)) {
            return transfersProgress[key].last();
        }
        return 0;
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getTransfersProgressKey(const int idx) const {
        //LogMgr::debug(Q_FUNC_INFO);
        if(transfersProgress.size() > 0 && idx < transfersProgress.size() && idx >= 0) {
            return transfersProgress.keys().at(idx);
        }
        return "";
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE inline void clearTransfersProgress() {
        std::lock_guard<std::mutex> lock(mut);
        LogMgr::debug(Q_FUNC_INFO);
        transfersProgress.clear();
    }
private:
    QMap<QString, QStringList> transfers;
    QMap<QString, TransferMode> modes;
    static QMap<QString, QList<unsigned long>> transfersProgress;
    static std::mutex mut;
};

#endif // FILETRANSFERSMODEL_H
