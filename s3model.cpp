#include "s3model.h"

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

void S3Model::addS3Item(const S3Item &animal)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_s3items << animal;
    endInsertRows();
}

int S3Model::rowCount(const QModelIndex & parent) const {
    Q_UNUSED(parent);
    return m_s3items.count();
}

QString S3Model::s3Path() const {
    return QString("s3://");
}


QVariant S3Model::data(const QModelIndex & index, int role) const {
    if (index.row() < 0 || index.row() >= m_s3items.count())
        return QVariant();

    const S3Item &animal = m_s3items[index.row()];
    if (role == NameRole)
        return animal.fileName();
    else if (role == PathRole)
        return animal.filePath();
    else if (role == S3PathRole)
        return s3Path();
    return QVariant();
}

QHash<int, QByteArray> S3Model::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[NameRole] = "fileName";
    roles[PathRole] = "filePath";
    roles[S3PathRole] = "s3Path";
    return roles;
}
