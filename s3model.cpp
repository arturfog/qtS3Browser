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
    m_s3Path.push_back("s3://");
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
    if (m_s3Path.count() >= 2) {
        m_s3Path.removeLast();

        if(m_s3Path.count() == 1) {
            getBuckets();
        }
    }
}

QString S3Model::getCurrentBucket() const
{
    if (m_s3Path.count() >= 2) {
        return m_s3Path[1];
    }

    return "";
}

QString S3Model::s3Path() const {
    QString path = m_s3Path.join("/");
    return path;
}

void S3Model::getObjects(const std::string &item, bool refresh) {
    clearItems();

    QString qsKey(item.c_str());
    QString qsBucket = getCurrentBucket();

    if(refresh == false || qsBucket.isEmpty()) {
        goTo(item.c_str());
        qsBucket = getCurrentBucket();
        qDebug() << "2 item: [" << qsKey << "] bucket[" << qsBucket << "]";
    }

    if(qsKey.compare(qsBucket) == 0) {
        qsKey = "";
    }

    if(qsKey == "" || qsKey.contains("/")) {
        qDebug() << "3 item: [" << qsKey << "] bucket[" << qsBucket << "]";
        std::vector<std::string> objects;
        s3.listObjects(qsBucket.toStdString().c_str(), qsKey.toStdString().c_str(), objects);

        for(auto obj : objects) {
            QString qsItem(obj.c_str());
            addS3Item(S3Item(qsItem, qsBucket));
        }
    }
}

void S3Model::getBuckets() {
    clearItems();
    std::vector<std::string> buckets;
    s3.getBuckets(buckets);

    for(auto item : buckets) {
        addS3Item(S3Item(QString(item.c_str()), "/"));
    }
}

void S3Model::refresh()
{
    if(m_s3Path.count() <= 1) {
        getBuckets();
    } else {
        getObjects(getCurrentBucket().toStdString(), true);
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
