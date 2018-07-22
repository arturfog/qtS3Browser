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

#include "s3model.h"

#include <tuple>
#include <QDebug>
S3Item::S3Item(const QString &name, const QString &path)
    : m_name(name), m_path(path)
{
}

QString S3Item::fileName() const
{
    return m_name;
}

QString S3Item::filePath() const
{
    return m_path;
}

S3Model::S3Model(QObject *parent)
    : QAbstractListModel(parent)
{
    QObject::connect(this, &S3Model::addItemSignal, this, &S3Model::addItemSlot);
}

void S3Model::addS3Item(const S3Item &item)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_s3items << item;
    endInsertRows();
}

void S3Model::clearItems() {
    beginRemoveRows(QModelIndex(), 0, rowCount());
    m_s3items.clear();
    endRemoveRows();
}

int S3Model::rowCount(const QModelIndex & parent) const {
    Q_UNUSED(parent);
    return m_s3items.count();
}

void S3Model::goTo(const QString &path)
{
    m_s3Path.push_back(path);
}

void S3Model::goBack()
{
    if (m_s3Path.count() <= 1) {
        m_s3Path.removeLast();
        getBuckets();
    } else {
        m_s3Path.removeLast();
        qDebug() << "1 goBack: [" << getPathWithoutBucket() << "]";
        getObjects(getPathWithoutBucket().toStdString(), true);
    }
}

QString S3Model::getCurrentBucket() const
{
    if (m_s3Path.count() >= 1) {
        return m_s3Path[0];
    }

    return "";
}

QString S3Model::getPathWithoutBucket() const
{
    if (m_s3Path.count() >= 1) {
        return m_s3Path.mid(1).join("");
    }

    return "";
}

QString S3Model::s3Path() const {
    QString path = QString("s3://").append(getCurrentBucket());
    if(m_s3Path.count() >= 1) {
        path = path.append("/").append(getPathWithoutBucket());
    }
    return path;
}

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
/**
 * @brief S3Model::getObjectInfo
 * @param key
 */
void S3Model::getObjectInfo(const QString &key)
{
    s3.getObjectInfo(getCurrentBucket().toStdString().c_str(),
                     getPathWithoutBucket().append(key).toStdString().c_str());
}
/**
 * @brief S3Model::getBuckets
 */
void S3Model::getBuckets() {
    clearItems();
    std::function<void(const std::string&)> callback = [&](const std::string& item) {
        emit this->addItemSignal(QString(item.c_str()), "/");
    };
    s3.getBuckets(callback);
}
/**
 * @brief S3Model::refresh
 */
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

void S3Model::createBucket(const std::string &bucket)
{
    s3.createBucket(bucket.c_str());
}

void S3Model::createFolder(const std::string &folder)
{
    s3.createFolder(getCurrentBucket().toStdString().c_str(), folder.c_str());
}

void S3Model::removeBucket(const std::string &bucket)
{
    s3.deleteBucket(bucket.c_str());
}

void S3Model::removeObject(const std::string &key)
{
    s3.deleteObject(getCurrentBucket().toStdString().c_str(), key.c_str());
}

void S3Model::upload(const QString& file)
{
    QString filename(file.split("/").last());
    s3.uploadFile(getCurrentBucket().toStdString().c_str(),
                  getPathWithoutBucket().append(filename).toStdString().c_str(),
                  file.toStdString().c_str());
}

void S3Model::download(const QString &key)
{
    QString out_file = key.split("/").last();
    s3.downloadFile(getCurrentBucket().toStdString().c_str(),
                    getPathWithoutBucket().append(out_file).toStdString().c_str(),
                    QString("/tmp/").append(out_file).toStdString().c_str());
}

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

QHash<int, QByteArray> S3Model::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[NameRole] = "fileName";
    roles[PathRole] = "filePath";
    return roles;
}
