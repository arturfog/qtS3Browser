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
    : QAbstractListModel(parent)
{
    QObject::connect(this, &S3Model::addItemSignal, this, &S3Model::addItemSlot);
    loadBookmarks();
    readCLIConfig();
}
// --------------------------------------------------------------------------
void S3Model::addS3Item(const S3Item &item)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_s3items << item;
    endInsertRows();
}
// --------------------------------------------------------------------------
void S3Model::clearItems() {
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
    m_s3Path.push_back(path);
}
// --------------------------------------------------------------------------
void S3Model::goBack()
{
    if (m_s3Path.count() <= 1) {
        if(m_s3Path.count() == 1) {
            m_s3Path.removeLast();
        }
        getBuckets();
    } else {
        m_s3Path.removeLast();
        qDebug() << "1 goBack: [" << getPathWithoutBucket() << "]";
        getObjects(getPathWithoutBucket().toStdString(), true);
    }
}
// --------------------------------------------------------------------------
QString S3Model::getCurrentBucket() const
{
    if (m_s3Path.count() >= 1) {
        return m_s3Path[0];
    }
    return "";
}
// --------------------------------------------------------------------------
QString S3Model::getPathWithoutBucket() const
{
    if (m_s3Path.count() >= 1) {
        return m_s3Path.mid(1).join("");
    }
    return "";
}
// --------------------------------------------------------------------------
QString S3Model::s3Path() const {
    QString path = QString("s3://").append(getCurrentBucket());
    if(m_s3Path.count() >= 1) {
        path = path.append("/").append(getPathWithoutBucket());
    }
    return path;
}
// --------------------------------------------------------------------------
void S3Model::getObjects(const std::string &item, bool goBack) {

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

        qDebug() << "3 qsKey: [" << qsKey << "] bucket[" << qsBucket << "]";
        s3.listObjects(qsBucket.toStdString().c_str(), qsKey.toStdString().c_str(), callback);
    }
}
// --------------------------------------------------------------------------
void S3Model::getObjectInfo(const QString &key)
{
    s3.getObjectInfo(getCurrentBucket().toStdString().c_str(),
                     getPathWithoutBucket().append(key).toStdString().c_str());
}
// --------------------------------------------------------------------------
void S3Model::addBookmark(const QString &name, const QString &path)
{
    if(!bookmarks.contains(name)) {
        bookmarks[name] = path;
        saveBookmarks(bookmarks);
    }
}
// --------------------------------------------------------------------------
void S3Model::removeBookmark(const QString& name)
{
    if(bookmarks.contains(name)) {
        bookmarks.remove(name);
        saveBookmarks(bookmarks);
    }
}
// --------------------------------------------------------------------------
void S3Model::saveBookmarks(QMap<QString, QString> &bookmarks)
{
    QFile file("bookmarks.dat");
    file.open(QIODevice::WriteOnly);
    QDataStream out(&file);
    out << bookmarks;
    file.close();
}
// --------------------------------------------------------------------------
void S3Model::loadBookmarks()
{
    QFile file("bookmarks.dat");
    if(file.exists()) {
        file.open(QIODevice::ReadOnly);
        QDataStream in(&file);
        in >> bookmarks;
    }
}
// --------------------------------------------------------------------------
void S3Model::getBuckets() {
    clearItems();
    std::function<void(const std::string&)> callback = [&](const std::string& item) {
        emit this->addItemSignal(QString(item.c_str()), "/");
    };
    s3.getBuckets(callback);
}
// --------------------------------------------------------------------------
void S3Model::refresh()
{
    if(m_s3Path.count() <= 0) {
        qDebug() << "1 refresh: [" << getPathWithoutBucket() << "]";
        getBuckets();
    } else {
        qDebug() << "refresh: [" << getPathWithoutBucket() << "]";
        getObjects(getPathWithoutBucket().toStdString(), true);
    }
}
// --------------------------------------------------------------------------
void S3Model::createBucket(const std::string &bucket)
{
    s3.createBucket(bucket.c_str());
}
// --------------------------------------------------------------------------
void S3Model::createFolder(const QString &folder)
{
    s3.createFolder(getCurrentBucket().toStdString().c_str(),
                    QString(folder).append("/_empty_file_to_remove").toStdString().c_str());
}
// --------------------------------------------------------------------------
void S3Model::removeBucket(const std::string &bucket)
{
    s3.deleteBucket(bucket.c_str());
}
// --------------------------------------------------------------------------
void S3Model::removeObject(const std::string &key)
{
    s3.deleteObject(getCurrentBucket().toStdString().c_str(), key.c_str());
}
// --------------------------------------------------------------------------
void S3Model::upload(const QString& file)
{
    std::function<void(const unsigned long long, const unsigned long long)> callback = [&](const unsigned long long bytes, const unsigned long long total) {
        emit this->setProgressSignal(bytes, total);
    };

    QString filename(file.split("/").last());
    currentFile = filename;
    s3.uploadFile(getCurrentBucket().toStdString().c_str(),
                  getPathWithoutBucket().append(filename).toStdString().c_str(),
                  file.toStdString().c_str(), callback);
}
// --------------------------------------------------------------------------
void S3Model::download(const QString &key)
{
    std::function<void(const unsigned long long, const unsigned long long)> callback = [&](const unsigned long long bytes, const unsigned long long total) {
        emit this->setProgressSignal(bytes, total);
    };

    QString out_file = key.split("/").last();
    currentFile = out_file;
    s3.downloadFile(getCurrentBucket().toStdString().c_str(),
                    getPathWithoutBucket().append(out_file).toStdString().c_str(),
                    QString("/tmp/").append(out_file).toStdString().c_str(), callback);
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
QString S3Model::getStartPath() const { return settings.value("StartPath").toString(); }
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
