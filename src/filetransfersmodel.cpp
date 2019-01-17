#include "inc/filetransfersmodel.h"

QMap<QString, QStringList> FileTransfersModel::transfers;
QMap<QString, FileTransfersModel::TransferMode> FileTransfersModel::modes;
QMap<QString, QList<unsigned long>> FileTransfersModel::transfersProgress;
std::mutex FileTransfersModel::mut;
// --------------------------------------------------------------------------
FileTransfersModel::FileTransfersModel(QObject *parent) : QObject(parent) {
    QObject::connect(this, &FileTransfersModel::addTransferProgressSignal, this, &FileTransfersModel::addTransferProgressSlot);
}
// --------------------------------------------------------------------------
Q_INVOKABLE void FileTransfersModel::clearTransfersQueue()
{
    LogMgr::debug(Q_FUNC_INFO);
    modes.clear();
    transfers.clear();
}
// --------------------------------------------------------------------------
Q_INVOKABLE void FileTransfersModel::addTransferToQueueQML(const QString &fileName,
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
Q_SLOT void FileTransfersModel::addTransferProgressSlot(const QString& key,
                                    const unsigned long current,
                                    const unsigned long total) {
    //LogMgr::debug(Q_FUNC_INFO, key);
    std::lock_guard<std::mutex> lock(mut);
    if(!key.isEmpty()) {
        if(transfersProgress.size() <= 200) {
            transfersProgress.insert(key, { current, total });
        } else {

        }
    }
}
// --------------------------------------------------------------------------
Q_INVOKABLE const QString FileTransfersModel::getTransfersProgressKey(const int idx) const {
    //LogMgr::debug(Q_FUNC_INFO);
    std::lock_guard<std::mutex> lock(mut);
    if(transfersProgress.size() > 0 && idx < transfersProgress.size() && idx >= 0) {
        return transfersProgress.keys().at(idx);
    }
    return "";
}
// --------------------------------------------------------------------------
Q_INVOKABLE void FileTransfersModel::removeTransferQML(const int idx) {
    LogMgr::debug(Q_FUNC_INFO);
    if(transfers.size() > 0 && idx < transfers.size() && idx >= 0) {
        QString fileName(transfers.keys().at(idx));
        transfers.remove(fileName);
        modes.remove(fileName);
    }
}
// --------------------------------------------------------------------------
Q_INVOKABLE void FileTransfersModel::removeTransferQML(const QString &fileName) {
    LogMgr::debug(Q_FUNC_INFO, fileName);
    if(!fileName.isEmpty() && transfers.contains(fileName)) {
        transfers.remove(fileName);
        modes.remove(fileName);
    }
}
// --------------------------------------------------------------------------
Q_INVOKABLE void FileTransfersModel::clearTransfersProgress() {
    std::lock_guard<std::mutex> lock(mut);
    LogMgr::debug(Q_FUNC_INFO);
    transfersProgress.clear();
}
// --------------------------------------------------------------------------
void FileTransfersModel::removeTransferProgressQML(const QString &key)
{
    if(transfersProgress.contains(key)) {
        transfersProgress.remove(key);
    }
}
// --------------------------------------------------------------------------
