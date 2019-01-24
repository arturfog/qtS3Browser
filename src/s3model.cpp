/*
# Copyright (C) 2018  Artur Fogiel
# This file is part of qtS3Browser.
#
# qtS3Browser is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# qtS3Browser is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with qtS3Browser.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "inc/s3model.h"

#include <tuple>
#include <QDebug>
#include <QSysInfo>
#include <QDir>
#include <QTextStream>
#include <QFile>
#include <QDataStream>

FilesystemModel S3Model::fsm;
SettingsModel S3Model::sm;
FileTransfersModel S3Model::ftm;
std::mutex S3Model::mut;
QList<S3Item> S3Model::m_s3items;
QStringList S3Model::m_s3Path;
// --------------------------------------------------------------------------
S3Item::S3Item(const QString &name, const QString &path)
    : m_name(name), m_path(path)
{
}
// --------------------------------------------------------------------------
QString S3Item::fileName() const
{
    return m_name;
}
// --------------------------------------------------------------------------
QString S3Item::filePath() const
{
    return m_path;
}
// --------------------------------------------------------------------------
S3Model::S3Model(QObject *parent)
    : QAbstractListModel(parent),
      isConnected(false),
      mFileBrowserPath(),
      m_s3itemsBackup()
{
    QObject::connect(this, &S3Model::addItemSignal, this, &S3Model::addItemSlot);

    std::function<void(const std::string&)> errorCallback = [&](const std::string& msg) {
        emit this->showErrorSignal(msg.c_str());
    };

    s3.setErrorHandler(errorCallback);
    sm.readCLIConfig();

    if(getFileBrowserPath().isEmpty())
    {
        QString home("file://");
        setFileBrowserPath(home.append(fsm.getHomePath()));
    }

    std::function<void(const unsigned long long, const unsigned long long,
                       const std::string&)> progressCallback = [&](
            const unsigned long long bytes,
            const unsigned long long total,
            const std::string& key)
    {
        emit ftm.addTransferProgressSignal(key.c_str(), bytes, total);
        emit this->setProgressSignal(bytes, total);

    };
    s3.setProgressCallback(progressCallback);

    std::function<void()> refreshCallback = [&]() { refresh(); };
    s3.setRefreshCallback(refreshCallback);

    LogMgr::openLog();
}
// --------------------------------------------------------------------------
Q_INVOKABLE QString S3Model::getFileBrowserPath() const {
    //LogMgr::debug(Q_FUNC_INFO);
    return mFileBrowserPath;
}
// --------------------------------------------------------------------------
Q_INVOKABLE bool S3Model::canDownload() const {
    //LogMgr::debug(Q_FUNC_INFO, getFileBrowserPath());
    const QFileInfo fileInfo(getFileBrowserPath());
    if(fileInfo.isDir() && fileInfo.isWritable()) {
        return true;
    }
    return false;
}
// --------------------------------------------------------------------------
Q_INVOKABLE bool S3Model::canDownload(const QString &path) const {
    //LogMgr::debug(Q_FUNC_INFO, getFileBrowserPath());
    const QFileInfo fileInfo(path);
    if(fileInfo.isDir() && fileInfo.isWritable()) {
        return true;
    }
    return false;
}
// --------------------------------------------------------------------------
Q_INVOKABLE void S3Model::setFileBrowserPath(const QString& path) {
    LogMgr::debug(Q_FUNC_INFO, path);
    if(!path.isEmpty()) {
        mFileBrowserPath = path;
        mFileBrowserPath = mFileBrowserPath.replace("file://", "").append("/");
    }
}
// --------------------------------------------------------------------------
Q_INVOKABLE void S3Model::downloadQML(const int idx) {
    LogMgr::debug(Q_FUNC_INFO);
    if (idx >= 0 && idx < m_s3items.count()) {
        if(getCurrentPathDepth() >= 1) {
            bool isDir = false;
            if(m_s3items.at(idx).filePath().compare("/") == 0) {
                isDir = true;
            }

            ftm.setTransferDirection(FileTransfersModel::TransferMode::download);
            download(m_s3items.at(idx).fileName(), isDir);
        }
    }
}
// --------------------------------------------------------------------------
void S3Model::uploadQML(const QString &src, const QString &dst)
{
    LogMgr::debug(Q_FUNC_INFO, src);
    if(isConnected && (src.isEmpty() == false) && (dst.isEmpty() == false))
    {
        QString tmpDst(dst);
        QStringList dstList = tmpDst.replace("s3://", "").split("/");
        if(!dstList.isEmpty())
        {
            const QString bucket(dstList[0]);
            dstList.takeFirst();
            const QString key(dstList.join("/"));

            if(!key.isEmpty() && !bucket.isEmpty())
            {
                QString tmpSrc(src);
                tmpSrc.replace("file://", "");

                ftm.setTransferDirection(FileTransfersModel::TransferMode::upload);

                const QFileInfo fileInfo(tmpSrc);
                if(fileInfo.isDir() && fileInfo.isWritable()) {
                    m_currentUploadBytes = fsm.getFolderSizeInKB(tmpSrc);
                    s3.uploadDirectory(bucket.toStdString().c_str(),
                                       key.toStdString().c_str(),
                                       tmpSrc.toStdString().c_str());
                } else {
                    m_currentUploadBytes = fsm.getFileSizeInKB(tmpSrc);
                    s3.uploadFile(bucket.toStdString().c_str(),
                                  key.toStdString().c_str(),
                                  tmpSrc.toStdString().c_str());
                }
            }
        }
    }
}
// --------------------------------------------------------------------------
void S3Model::downloadQML(const QString &src, const QString &dst)
{
    LogMgr::debug(Q_FUNC_INFO, src);
    if(isConnected && (src.isEmpty() == false) && (dst.isEmpty() == false))
    {
        QString tmpSrc(src);
        QStringList srcList = tmpSrc.replace("s3://", "").split("/");
        if(!srcList.isEmpty())
        {
            const QString bucket(srcList[0]);
            srcList.takeFirst();
            const QString key(srcList.join("/"));

            if(!key.isEmpty() && !bucket.isEmpty())
            {
                ftm.setTransferDirection(FileTransfersModel::TransferMode::download);
                QString tmpDst(dst);
                // TODO: check if source exist

                tmpDst.replace("file://", "");
                QStringList dstList = tmpDst.split("/");
                if(!dstList.empty()) {
                    // remove filename from dest dir path
                    const QString filename = dstList.takeLast();
                    QString dstDir = dstList.join("/");
                    // destination exist and is directory

                    if(filename.compare("") == 0) {
                        dstList.takeLast();
                        dstDir = dstList.join("/");
                    }

                    if(canDownload(dstDir))
                    {
                        if(filename.compare("") == 0) {
                            s3.downloadDirectory(bucket.toStdString().c_str(),
                                             key.toStdString().c_str(),
                                             tmpDst.toStdString().c_str());
                        } else {
                            s3.downloadFile(bucket.toStdString().c_str(),
                                        key.toStdString().c_str(),
                                        tmpDst.toStdString().c_str());
                        }
                    }
                }
            }
        }
    }
}
// --------------------------------------------------------------------------
Q_INVOKABLE void S3Model::gotoQML(const QString &path) {
    LogMgr::debug(Q_FUNC_INFO, path);
    if(!path.isEmpty()) {
        const QStringList pathItems = path.split("s3://");
        // if more then 2, path is invalid and contains more than one 's3://'
        if(pathItems.count() == 2) {
            m_s3Path.clear();
            for(auto item: pathItems[1].split("/")) {
                if(!item.isEmpty()) {
                    m_s3Path.append(item + "/");
                }
            }
            refresh();
        }
    }
}
// --------------------------------------------------------------------------
Q_INVOKABLE void S3Model::removeQML(const int idx) {
    LogMgr::debug(Q_FUNC_INFO);
    if (idx < m_s3items.count() && idx >= 0) {
        if(getCurrentPathDepth() <= 0) {
            removeBucket(m_s3items.at(idx).fileName().toStdString());
        } else {
            bool isDir(false);
            if(m_s3items.at(idx).filePath().compare("/") == 0) {
                isDir = true;
            }
            const QString filename(m_s3items.at(idx).fileName());
            removeObject(getPathWithoutBucket().append(filename), isDir);
        }
    }
}
// --------------------------------------------------------------------------
QString S3Model::getObjectSizeQML(const QString &name)
{
    //LogMgr::debug(Q_FUNC_INFO, name);
    auto search = s3.objectInfoVec.find(name.toStdString().c_str());
    if (search != s3.objectInfoVec.end()) {
        return QString::number(s3.objectInfoVec.at(name.toStdString().c_str()).size);
    } else {
        return "0";
    }
}
// --------------------------------------------------------------------------
void S3Model::saveSettingsQML(const QString &startPath,
                              const QString &accessKey,
                              const QString &secretKey,
                              const int regionIdx,
                              const QString &region,
                              const int timeoutIdx,
                              const QString &timeout,
                              const QString &endpoint,
                              const QString &logsDir,
                              const bool logsEnabled)
{
    LogMgr::debug(Q_FUNC_INFO);
    settings.setValue("StartPath", startPath);
    settings.setValue("AccessKey", accessKey);
    settings.setValue("SecretKey", secretKey);
    settings.setValue("RegionIdx", regionIdx);
    settings.setValue("Region", region);
    settings.setValue("Endpoint", endpoint);
    settings.setValue("TimeoutIdx", timeoutIdx);
    settings.setValue("Timeout", timeout);
    settings.setValue("LogsDir", logsDir);
    settings.setValue("LogsEnabled", logsEnabled);
    settings.sync();

    s3.reloadCredentials();
}
// --------------------------------------------------------------------------
const QString S3Model::generatePresignLinkQML(const QString& key, const int timeoutSec)
{
    LogMgr::debug(Q_FUNC_INFO, key, timeoutSec);
    if(!key.isEmpty()) {
        const std::string bucket(getCurrentBucket().toStdString());
        const std::string link(s3.getPresignLink(bucket.c_str(),
                                                 key.toStdString().c_str(),
                                                 timeoutSec));

        return link.c_str();
    }

    return QString();
}
// --------------------------------------------------------------------------
void S3Model::addS3Item(const S3Item &item)
{
    //LogMgr::debug(Q_FUNC_INFO, item.fileName());
    std::lock_guard<std::mutex> lock(mut);
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_s3items << item;
    endInsertRows();
}
// --------------------------------------------------------------------------
void S3Model::clearItems() {
    std::lock_guard<std::mutex> lock(mut);
    LogMgr::debug(Q_FUNC_INFO);
    beginRemoveRows(QModelIndex(), 0, rowCount());
    m_s3items.clear();
    endRemoveRows();
}
// --------------------------------------------------------------------------
int S3Model::rowCount(const QModelIndex & parent) const {
    Q_UNUSED(parent);
    return m_s3items.length();
}
// --------------------------------------------------------------------------
void S3Model::goTo(const QString &path)
{
    LogMgr::debug(Q_FUNC_INFO, path);
    if(!path.isEmpty()) {
        if(!path.contains("/")) {
            m_s3Path.push_back(path + "/");
        } else {
            m_s3Path.push_back(path);
        }
    }
}
// --------------------------------------------------------------------------
void S3Model::goBack()
{
    LogMgr::debug(Q_FUNC_INFO);
    if(!m_s3Path.isEmpty()) { m_s3Path.removeLast(); }
    if (m_s3Path.count() < 1) {
        getBuckets();
    } else {
        getObjects(getPathWithoutBucket().toStdString(), true);
    }
}
// --------------------------------------------------------------------------
QString S3Model::getCurrentBucket() const
{
    LogMgr::debug(Q_FUNC_INFO);
    if (m_s3Path.count() >= 1) {
        QString tmp(m_s3Path[0]);
        return tmp.replace("/", "");
    }
    return "";
}
// --------------------------------------------------------------------------
QString S3Model::getPathWithoutBucket() const
{
    //LogMgr::debug(Q_FUNC_INFO);
    if (m_s3Path.count() >= 1) {
        return m_s3Path.mid(1).join("");
    }
    return "";
}
// --------------------------------------------------------------------------
void S3Model::addItemSlot(const QString &item, const QString &path)
{
    setConnectedQML(true);
    if(!item.isEmpty())
    {
        addS3Item(S3Item(item, path));
    }
    else
    {
        if(getCurrentPathDepthQML() <= 0)
        {
            emit noBucketsSignal();
        }
    }
}
// --------------------------------------------------------------------------
QString S3Model::getS3PathQML() const {
    LogMgr::debug(Q_FUNC_INFO);
    QString path(m_s3Path.join(""));
    return path;
}
// --------------------------------------------------------------------------
void S3Model::getObjects(const std::string &item, bool goBack) {
    LogMgr::debug(Q_FUNC_INFO, item);
    emit this->clearItemsSignal();

    std::function<void(const std::string&)> callback = [&](const std::string& item) {
        if(!item.empty()) {
            QString qsItem(item.c_str());
            qsItem.replace(getPathWithoutBucket(), "");

            QString path(qsItem);
            if(qsItem.contains("/")) {
              path = "/";
            }

            emit this->addItemSignal(qsItem, path);
        }
    };
    QString qsBucket(getCurrentBucket());
    if(qsBucket.isEmpty() && (item.empty() == false)) {
        emit this->clearItemsSignal();
        goTo(item.c_str());
        qsBucket = getCurrentBucket();
    }
    QString qsKey(item.c_str());
    if(qsKey.compare(qsBucket) == 0 || item.empty()) {
        qsKey = "";
    }
    if(qsKey.isEmpty() || qsKey.contains("/")) {
        emit this->clearItemsSignal();
        if (qsKey.contains("/")) {
            if(goBack == false) {
                goTo(item.c_str());
            }
            qsKey = getPathWithoutBucket();
        }
        s3.currentPrefix = getPathWithoutBucket().toStdString().c_str();
        s3.listObjects(qsBucket.toStdString().c_str(), qsKey.toStdString().c_str(), "", callback);
    }
}
// --------------------------------------------------------------------------
void S3Model::getObjectInfo(const QString &key)
{
    LogMgr::debug(Q_FUNC_INFO, key);
    if(!key.isEmpty()) {
        s3.getObjectInfo(getCurrentBucket().toStdString().c_str(),
                     getPathWithoutBucket().append(key).toStdString().c_str());
    }
}
// --------------------------------------------------------------------------
void S3Model::getBuckets() {
    LogMgr::debug(Q_FUNC_INFO);
    emit this->clearItemsSignal();

    std::function<void(const std::string&)> callback = [&](const std::string& item) {
        emit this->addItemSignal(QString(item.c_str()), "/");
    };
    s3.getBuckets(callback);
}
// --------------------------------------------------------------------------
void S3Model::refresh()
{
    LogMgr::debug(Q_FUNC_INFO);
    if(m_s3Path.count() <= 0) {
        getBuckets();
    } else {
        getObjects(getPathWithoutBucket().toStdString(), true);
    }
}
// --------------------------------------------------------------------------
void S3Model::createBucket(const std::string &bucket)
{
    LogMgr::debug(Q_FUNC_INFO, bucket);

    if(!bucket.empty()) {
        s3.createBucket(bucket.c_str());
    }
}
// --------------------------------------------------------------------------
bool S3Model::createFolderQML(const QString &folder)
{
    LogMgr::debug(Q_FUNC_INFO, folder);

    if(folder.contains("/")) {
	    // two "/" sign present. return error
        return false;
    }

    if(!folder.isEmpty()) {
        QString tmpFolder(folder);
        const std::string folderPath = QString(getPathWithoutBucket()).append(tmpFolder).append("/_empty_file_to_remove").toStdString();
        s3.createFolder(getCurrentBucket().toStdString().c_str(), folderPath.c_str());
        return true;
    }

    return false;
}
// --------------------------------------------------------------------------
void S3Model::removeBucket(const std::string &bucket)
{
    LogMgr::debug(Q_FUNC_INFO, bucket);
    if(!bucket.empty())
    {
        s3.deleteBucket(bucket.c_str());
    }
}
// --------------------------------------------------------------------------
void S3Model::removeObject(const QString &key, bool isDir)
{
    LogMgr::debug(Q_FUNC_INFO, key);

    if(!key.isEmpty()) {
        clearItems();
        const std::string bucket(getCurrentBucket().toStdString());
        if(isDir) {
            s3.deleteDirectory(bucket.c_str(), key.toStdString().c_str());
        } else {
            s3.deleteObject(bucket.c_str(), key.toStdString().c_str());
        }
    }
}
// --------------------------------------------------------------------------
void S3Model::upload(const QString& file, bool isDir)
{
    LogMgr::debug(Q_FUNC_INFO, file);
    std::function<void()> refreshCallback = [&]() { refresh(); };

    QString filename(file.split("/").last());
    const std::string bucket = getCurrentBucket().toStdString();
    const std::string key = getPathWithoutBucket().append(filename).toStdString();

    ftm.setTransferDirection(FileTransfersModel::TransferMode::upload);
    if(isDir) {
        m_currentUploadBytes = fsm.getFolderSizeInKB(file);
        s3.uploadDirectory(bucket.c_str(), key.c_str(), file.toStdString().c_str());
    } else {
        m_currentUploadBytes = fsm.getFileSizeInKB(file);
        s3.uploadFile(bucket.c_str(), key.c_str(), file.toStdString().c_str());
    }
}
// --------------------------------------------------------------------------
void S3Model::download(const QString &key, bool isDir)
{
    LogMgr::debug(Q_FUNC_INFO, key);
    if(!key.isEmpty()) {
        QString out_file(key.split("/").last());
        if(isDir) {
            out_file = key;
        }

        const std::string src(getPathWithoutBucket().append(out_file).toStdString());
        const std::string dst(getFileBrowserPath().append(out_file).toStdString());

        ftm.setTransferDirection(FileTransfersModel::TransferMode::download);
        if(isDir) {
            s3.downloadDirectory(getCurrentBucket().toStdString().c_str(), src.c_str(), dst.c_str());
        } else {
            s3.downloadFile(getCurrentBucket().toStdString().c_str(), src.c_str(), dst.c_str());
        }
    }
}
// --------------------------------------------------------------------------
QVariant S3Model::data(const QModelIndex &index, int role) const {
    if (index.row() < 0 || index.row() >= m_s3items.count())
        return QVariant();

    const S3Item &item = m_s3items[index.row()];
    if (role == NameRole)
        return item.fileName();
    else if (role == PathRole)
        return item.filePath();
    return QVariant();
}
// --------------------------------------------------------------------------
QHash<int, QByteArray> S3Model::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[NameRole] = "fileName";
    roles[PathRole] = "filePath";
    return roles;
}
