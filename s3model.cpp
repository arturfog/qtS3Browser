#include "s3model.h"

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
}

void S3Model::addS3Item(const S3Item &item)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_s3items << item;
    endInsertRows();
}

int S3Model::rowCount(const QModelIndex & parent) const {
    Q_UNUSED(parent);
    return m_s3items.count();
}

QString S3Model::s3Path() const {
    qInfo() << "Getting path";
    return QString("s3://");
}

void S3Model::getObjects(const std::string &bucket) {
    std::vector<std::string> objects;
    s3.listObjects(bucket.c_str(), objects);
}

void S3Model::getBuckets() {
    std::vector<std::string> buckets;
    s3.getBuckets(buckets);

    for(auto item : buckets) {
        addS3Item(S3Item(QString(item.c_str()), "Large"));
    }
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
