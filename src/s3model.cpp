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
      bookmarks(),
      isConnected(false),
      mFileBrowserPath(),
      m_s3itemsBackup()
{
    QObject::connect(this, &S3Model::addItemSignal, this, &S3Model::addItemSlot);

    std::function<void(const std::string&)> callback = [&](const std::string& msg) {
        emit this->showErrorSignal(msg.c_str());
    };

    s3.setErrorHandler(callback);

    loadBookmarks();
    readCLIConfig();

    if(getFileBrowserPath().isEmpty())
    {
        QString home = "file://";
        setFileBrowserPath(home.append(fsm.getHomePath()));
    }
}
// --------------------------------------------------------------------------
Q_INVOKABLE QString S3Model::getFileBrowserPath() const {
    LogMgr::debug(Q_FUNC_INFO);
    return mFileBrowserPath;
}
// --------------------------------------------------------------------------
Q_INVOKABLE bool S3Model::canDownload() const {
    LogMgr::debug(Q_FUNC_INFO, getFileBrowserPath());
    const QFileInfo fileInfo = QFileInfo(getFileBrowserPath());
    if(fileInfo.isDir() && fileInfo.isWritable()) {
        return true;
    }
    return false;
}
// --------------------------------------------------------------------------
Q_INVOKABLE void S3Model::setFileBrowserPath(const QString& path) {
    LogMgr::debug(Q_FUNC_INFO, path);
    mFileBrowserPath = path;
    mFileBrowserPath = mFileBrowserPath.replace("file://", "").append("/");
}
// --------------------------------------------------------------------------
Q_INVOKABLE void S3Model::downloadQML(const int idx) {
    LogMgr::debug(Q_FUNC_INFO);
    if (idx < m_s3items.count()) {
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
Q_INVOKABLE void S3Model::gotoQML(const QString &path) {
    LogMgr::debug(Q_FUNC_INFO, path);
    m_s3Path.clear();
    QStringList pathItems = path.split("s3://");
    if(pathItems.count() > 1) {
        for(auto item: pathItems[1].split("/")) {
            if(!item.isEmpty()) {
                m_s3Path.append(item + "/");
            }
        }
        refresh();
    }
}
// --------------------------------------------------------------------------
Q_INVOKABLE void S3Model::removeQML(const int idx) {
    LogMgr::debug(Q_FUNC_INFO);
    if (idx < m_s3items.count() && idx >= 0) {
        if(getCurrentPathDepth() <= 0) {
            removeBucket(m_s3items.at(idx).fileName().toStdString());
        } else {

            bool isDir = false;
            if(m_s3items.at(idx).filePath().compare("/") == 0) {
                isDir = true;
            }

            const QString filename = m_s3items.at(idx).fileName();
            removeObject(getPathWithoutBucket().append(filename), isDir);
        }
    }
}
// --------------------------------------------------------------------------
void S3Model::addS3Item(const S3Item &item)
{
    LogMgr::debug(Q_FUNC_INFO, item.fileName());
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_s3items << item;
    endInsertRows();
}
// --------------------------------------------------------------------------
void S3Model::clearItems() {
    LogMgr::debug(Q_FUNC_INFO);
    beginRemoveRows(QModelIndex(), 0, rowCount());
    m_s3items.clear();
    endRemoveRows();
}
// --------------------------------------------------------------------------
int S3Model::rowCount(const QModelIndex & parent) const {
    Q_UNUSED(parent);
    return m_s3items.count();
}
// --------------------------------------------------------------------------
void S3Model::goTo(const QString &path)
{
    LogMgr::debug(Q_FUNC_INFO, path);
    m_s3Path.push_back(path);
}
// --------------------------------------------------------------------------
void S3Model::goBack()
{
    LogMgr::debug(Q_FUNC_INFO);

    if (m_s3Path.count() <= 1) {
        if(m_s3Path.count() == 1) {
            m_s3Path.removeLast();
        }
        getBuckets();
    } else {
        m_s3Path.removeLast();
        getObjects(getPathWithoutBucket().toStdString(), true);
    }
}
// --------------------------------------------------------------------------
QString S3Model::getCurrentBucket() const
{
    LogMgr::debug(Q_FUNC_INFO);

    if (m_s3Path.count() >= 1) {
        return m_s3Path[0];
    }
    return "";
}
// --------------------------------------------------------------------------
QString S3Model::getPathWithoutBucket() const
{
    LogMgr::debug(Q_FUNC_INFO);

    if (m_s3Path.count() >= 1) {
        return m_s3Path.mid(1).join("");
    }
    return "";
}
// --------------------------------------------------------------------------
QString S3Model::s3Path() const {
    LogMgr::debug(Q_FUNC_INFO);
    QString path = getCurrentBucket();
    if(m_s3Path.count() >= 1) {
        path = path.append("/").append(getPathWithoutBucket());
    }
    return path;
}
// --------------------------------------------------------------------------
void S3Model::getObjects(const std::string &item, bool goBack) {
    LogMgr::debug(Q_FUNC_INFO, item);
    clearItems();
    QString qsBucket = getCurrentBucket();

    if(qsBucket.isEmpty()) {
        clearItems();
        goTo(item.c_str());
        qsBucket = getCurrentBucket();
    }

    QString qsKey(item.c_str());

    if(qsKey.compare(qsBucket) == 0) {
        qsKey = "";
    }

    std::function<void(const std::string&)> callback = [&](const std::string& item) {
        QString qsItem(item.c_str());
        qsItem.replace(getPathWithoutBucket(), "");
        QString path = qsItem;

        if(qsItem.contains("/")) {
          path = "/";
        }

        emit this->addItemSignal(qsItem, path);
    };

    if(qsKey == "" || qsKey.contains("/")) {
        clearItems();

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
    s3.getObjectInfo(getCurrentBucket().toStdString().c_str(),
                     getPathWithoutBucket().append(key).toStdString().c_str());
}
// --------------------------------------------------------------------------
void S3Model::addBookmark(const QString &name, const QString &path)
{
    LogMgr::debug(Q_FUNC_INFO, name);

    if(!name.isEmpty() && !path.isEmpty())
    {
        if(!bookmarks.contains(name)) {
            bookmarks[name] = path;
            saveBookmarks(bookmarks);
        }
    }
}
// --------------------------------------------------------------------------
void S3Model::removeBookmark(const QString& name)
{
    LogMgr::debug(Q_FUNC_INFO, name);

    if(!name.isEmpty())
    {
        if(bookmarks.contains(name)) {
            bookmarks.remove(name);
            saveBookmarks(bookmarks);
        }
    }
}
// --------------------------------------------------------------------------
void S3Model::saveBookmarks(QMap<QString, QString> &bookmarks)
{
    LogMgr::debug(Q_FUNC_INFO);

    QFile file("bookmarks.dat");
    file.open(QIODevice::WriteOnly);
    QDataStream out(&file);
    out << bookmarks;
    file.close();
}
// --------------------------------------------------------------------------
void S3Model::loadBookmarks()
{
    LogMgr::debug(Q_FUNC_INFO);

    QFile file("bookmarks.dat");
    if(file.exists()) {
        file.open(QIODevice::ReadOnly);
        QDataStream in(&file);
        in >> bookmarks;
    }
}
// --------------------------------------------------------------------------
void S3Model::getBuckets() {
    LogMgr::debug(Q_FUNC_INFO);
    clearItems();
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

    s3.createFolder(getCurrentBucket().toStdString().c_str(),
                    QString(getPathWithoutBucket()).append(QString(folder)).append("/_empty_file_to_remove").toStdString().c_str());
    return true;
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
    clearItems();
    std::function<void()> callbackObj = [&]() { refresh(); };
    std::function<void()> callbackDir = [&]() { refresh(); };
    if(isDir) {
        s3.deleteDirectory(getCurrentBucket().toStdString().c_str(),
                           key.toStdString().c_str(), callbackObj);
    } else {
        s3.deleteObject(getCurrentBucket().toStdString().c_str(),
                        key.toStdString().c_str(), callbackDir);
    }
}
// --------------------------------------------------------------------------
void S3Model::upload(const QString& file, bool isDir)
{
    LogMgr::debug(Q_FUNC_INFO, file);
    std::function<void(const unsigned long long, const unsigned long long)> callback = [&](const unsigned long long bytes, const unsigned long long total) {
        emit this->setProgressSignal(bytes, total);
    };

    QString filename(file.split("/").last());
    const std::string bucket = getCurrentBucket().toStdString();
    const std::string key = getPathWithoutBucket().append(filename).toStdString();

    currentFile = filename;

    if(isDir) {
        s3.uploadDirectory(bucket.c_str(),
                           key.c_str(),
                           file.toStdString().c_str(),
                           callback);
    } else {
        s3.uploadFile(bucket.c_str(),
                      key.c_str(),
                      file.toStdString().c_str(),
                      callback);
    }
}
// --------------------------------------------------------------------------
void S3Model::download(const QString &key, bool isDir)
{
    LogMgr::debug(Q_FUNC_INFO, key);
    std::function<void(const unsigned long long, const unsigned long long)> callback = [&](const unsigned long long bytes, const unsigned long long total) {
        emit this->setProgressSignal(bytes, total);
    };

    QString out_file;
    if(isDir) {
        out_file = key;
    } else {
        out_file = key.split("/").last();
    }

    // for progress window
    currentFile = out_file;

    if(isDir) {
        s3.downloadDirectory(getCurrentBucket().toStdString().c_str(),
                             getPathWithoutBucket().append(out_file).toStdString().c_str(),
                             getFileBrowserPath().append(out_file).toStdString().c_str(),
                             callback);
    } else {
        s3.downloadFile(getCurrentBucket().toStdString().c_str(),
                        getPathWithoutBucket().append(out_file).toStdString().c_str(),
                        getFileBrowserPath().append(out_file).toStdString().c_str(), callback);
    }
}
// --------------------------------------------------------------------------
QVariant S3Model::data(const QModelIndex & index, int role) const {
    if (index.row() < 0 || index.row() >= m_s3items.count())
        return QVariant();

    const S3Item &item = m_s3items[index.row()];
    if (role == NameRole)
        return item.fileName();
    else if (role == PathRole)
        return item.filePath();
    return QVariant();
}
// ----------------------------------------------------------------------------
QString S3Model::getAccessKey() const { return settings.value("AccessKey").toString(); }
// ----------------------------------------------------------------------------
QString S3Model::getSecretKey() const { return settings.value("SecretKey").toString(); }
// ----------------------------------------------------------------------------
QString S3Model::getStartPath() const { return settings.value("StartPath", "s3://").toString(); }
// ----------------------------------------------------------------------------
QString S3Model::extractKey(const QString& line) {
    const int startIdx = line.indexOf('=');
    if(startIdx > 0) {
        const QString key = line.mid(startIdx + 1).trimmed();
        return key;
    }
    return "Empty";
}
// ----------------------------------------------------------------------------
void S3Model::parseCLIConfig(const QString& credentialsFilePath) {
    LogMgr::debug(Q_FUNC_INFO, credentialsFilePath);

    QFile file(credentialsFilePath);
    if(!file.exists()) { return; }
    file.open(QIODevice::ReadOnly);
    if(file.isReadable()) {
        QTextStream in(&file);
        while (!in.atEnd()) {
            QString line = in.readLine();
            if(!line.isEmpty() && line.contains("access_key_id")) {
                settings.setValue("AccessKey", extractKey(line));
            } else if(!line.isEmpty() && line.contains("secret_access_key")) {
                settings.setValue("SecretKey", extractKey(line));
            }
        }
    }
}
// ----------------------------------------------------------------------------
void S3Model::readCLIConfig()
{
    LogMgr::debug(Q_FUNC_INFO);
    // credentials sample contents
    //
    // [default]
    // aws_access_key_id = abc
    // aws_secret_access_key = 1234
    //
    static const QString winDefaultLocation = "%UserProfile%\\.aws\\credentials";
    static const QString nixDefaultLocation = QDir::homePath() + "/.aws/credentials";

    // don't overwrite custom access/secret key set in app with those set in awscli
    if(settings.contains("AccessKey") && settings.contains("SecretKey")) {
        return;
    }

    QString os = QSysInfo::productType();
    if(os == "windows") {
         // Windows location is "%UserProfile%\.aws"
        parseCLIConfig(winDefaultLocation);
    } else {
        // MacOS/Linux/BSD location is $HOME/.aws
        parseCLIConfig(nixDefaultLocation);
    }
}
// --------------------------------------------------------------------------
QHash<int, QByteArray> S3Model::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[NameRole] = "fileName";
    roles[PathRole] = "filePath";
    return roles;
}
