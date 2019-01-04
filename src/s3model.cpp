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

std::mutex S3Model::mut;
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
      currentFile(),
      m_s3items(),
      isConnected(false),
      mFileBrowserPath(),
      m_s3itemsBackup()
{
    QObject::connect(this, &S3Model::addItemSignal, this, &S3Model::addItemSlot);

    std::function<void(const std::string&)> callback = [&](const std::string& msg) {
        emit this->showErrorSignal(msg.c_str());
    };

    s3.setErrorHandler(callback);
    sm.readCLIConfig();

    if(getFileBrowserPath().isEmpty())
    {
        QString home("file://");
        setFileBrowserPath(home.append(fsm.getHomePath()));
    }

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
    LogMgr::debug(Q_FUNC_INFO, getFileBrowserPath());
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

            download(m_s3items.at(idx).fileName(), isDir);
        }
    }
}
// --------------------------------------------------------------------------
void S3Model::uploadQML(const QString &src, const QString &dst)
{
    LogMgr::debug(Q_FUNC_INFO, src);

    std::function<void(const unsigned long long,
                       const unsigned long long, const std::string key)> callback = [&](const unsigned long long bytes,
            const unsigned long long total, const std::string key) {
        emit ftm.addTransferProgressSignal(key.c_str(), bytes, total);
        emit this->setProgressSignal(bytes, total);
    };



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
                s3.uploadFile(bucket.toStdString().c_str(),
                              key.toStdString().c_str(),
                              tmpSrc.toStdString().c_str(),
                              callback);
            }
        }
    }
}
// --------------------------------------------------------------------------
void S3Model::downloadQML(const QString &src, const QString &dst)
{
    LogMgr::debug(Q_FUNC_INFO, src);

    std::function<void(const unsigned long long,
                       const unsigned long long,
                       const std::string)> callback = [&](const unsigned long long bytes,
            const unsigned long long total, const std::string key) {
        emit ftm.addTransferProgressSignal(key.c_str(), bytes, total);
        emit this->setProgressSignal(bytes, total);
    };

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
                QString tmpDst(dst);
                // TODO: check if source exist

                tmpDst.replace("file://", "");
                QStringList dstList = tmpDst.split("/");
                // destination exist and is directory
                if(canDownload(tmpDst))
                {
                    s3.downloadDirectory(bucket.toStdString().c_str(),
                                         key.toStdString().c_str(),
                                         tmpDst.toStdString().c_str(),
                                         callback);
                } else {
                    // remove filename from dest dir path
                    const QString filename = dstList.takeLast();
                    const QString dstDir = dstList.join("/");
                    // dst dir exists
                    if(canDownload(dstDir))
                    {
                        currentFile = filename;
                        s3.downloadFile(bucket.toStdString().c_str(),
                                        key.toStdString().c_str(),
                                        tmpDst.toStdString().c_str(),
                                        callback);
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
void S3Model::addS3Item(const S3Item &item)
{
    std::lock_guard<std::mutex> lock(mut);
    LogMgr::debug(Q_FUNC_INFO, item.fileName());
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
        s3.listObjects(qsBucket.toStdString().c_str(), qsKey.toStdString().c_str(), callback);
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

    std::function<void(const unsigned long long,
                       const unsigned long long, const std::string key)> callback = [&](const unsigned long long bytes,
            const unsigned long long total, const std::string key) {
        emit ftm.addTransferProgressSignal(key.c_str(), bytes, total);
        emit this->setProgressSignal(bytes, total);
    };

    std::function<void()> refreshCallback = [&]() { refresh(); };

    QString filename(file.split("/").last());
    const std::string bucket = getCurrentBucket().toStdString();
    const std::string key = getPathWithoutBucket().append(filename).toStdString();

    currentFile = filename;

    if(isDir) {
        s3.uploadDirectory(bucket.c_str(), key.c_str(), file.toStdString().c_str(), callback);
    } else {
        s3.uploadFile(bucket.c_str(), key.c_str(), file.toStdString().c_str(), callback);
    }
}
// --------------------------------------------------------------------------
void S3Model::download(const QString &key, bool isDir)
{
    LogMgr::debug(Q_FUNC_INFO, key);

    std::function<void(const unsigned long long,
                       const unsigned long long,
                       const std::string)> callback = [&](const unsigned long long bytes,
            const unsigned long long total, const std::string key) {
        emit ftm.addTransferProgressSignal(key.c_str(), bytes, total);
        emit this->setProgressSignal(bytes, total);
    };

    if(!key.isEmpty()) {
        QString out_file(key.split("/").last());
        if(isDir) {
            out_file = key;
        }

        // for progress window
        currentFile = out_file;

        const std::string src(getPathWithoutBucket().append(out_file).toStdString());
        const std::string dst(getFileBrowserPath().append(out_file).toStdString());

        if(isDir) {
            s3.downloadDirectory(getCurrentBucket().toStdString().c_str(),
                                 src.c_str(), dst.c_str(), callback);
        } else {
            s3.downloadFile(getCurrentBucket().toStdString().c_str(),
                            src.c_str(), dst.c_str(), callback);
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
