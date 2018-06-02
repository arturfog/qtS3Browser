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

void S3Model::goTo(QString path)
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

QString S3Model::getCurrentBucket()
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

bool isFile(const QString &filename) {
    //if(filename.contains())
}

void S3Model::getObjects(const std::string &bucket) {
    clearItems();
    goTo(bucket.c_str());

    QString qsBucket(bucket.c_str());

    std::vector<std::string> objects;
    s3.listObjects(bucket.c_str(), objects);

    for(auto item : objects) {
        QString qsItem(item.c_str());
        addS3Item(S3Item(qsItem, qsBucket));
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
    if(m_s3Path.count() <= 2) {
        getBuckets();
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
