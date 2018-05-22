#include "s3model.h"

S3Model::S3Model(const QString &data, QObject *parent)
    : QAbstractItemModel(parent)
{
    QList<QVariant> rootData;
    rootData << "Title" << "Summary";
    rootItem = new S3Item(rootData);
    setupModelData(data.split(QString("\n")), rootItem);
}

S3Model::~S3Model()
{
    delete rootItem;
}

QModelIndex S3Model::index(int row, int column, const QModelIndex &parent)
            const
{
    if (!hasIndex(row, column, parent))
        return QModelIndex();

    S3Item *parentItem;

    if (!parent.isValid())
        parentItem = rootItem;
    else
        parentItem = static_cast<S3Item*>(parent.internalPointer());

    S3Item *childItem = parentItem->child(row);
    if (childItem)
        return createIndex(row, column, childItem);
    else
        return QModelIndex();
}

QModelIndex S3Model::parent(const QModelIndex &index) const
{
    if (!index.isValid())
        return QModelIndex();

    S3Item *childItem = static_cast<S3Item*>(index.internalPointer());
    S3Item *parentItem = childItem->parentItem();

    if (parentItem == rootItem)
        return QModelIndex();

    return createIndex(parentItem->row(), 0, parentItem);
}

int S3Model::rowCount(const QModelIndex &parent) const
{
    S3Item *parentItem;
    if (parent.column() > 0)
        return 0;

    if (!parent.isValid())
        parentItem = rootItem;
    else
        parentItem = static_cast<S3Item*>(parent.internalPointer());

    return parentItem->childCount();
}

int S3Model::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return static_cast<S3Item*>(parent.internalPointer())->columnCount();
    else
        return rootItem->columnCount();
}

QVariant S3Model::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (role != Qt::DisplayRole)
        return QVariant();

    S3Item *item = static_cast<S3Item*>(index.internalPointer());

    return item->data(index.column());
}

Qt::ItemFlags S3Model::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return 0;

    return QAbstractItemModel::flags(index);
}

QVariant S3Model::headerData(int section, Qt::Orientation orientation,
                               int role) const
{
    if (orientation == Qt::Horizontal && role == Qt::DisplayRole)
        return rootItem->data(section);

    return QVariant();
}

void S3Model::setupModelData(const QStringList &lines, S3Item *parent)
{
    QList<S3Item*> parents;
    QList<int> indentations;
    parents << parent;
    indentations << 0;

    int number = 0;

    while (number < lines.count()) {
        int position = 0;
        while (position < lines[number].length()) {
            if (lines[number].at(position) != ' ')
                break;
            position++;
        }

        QString lineData = lines[number].mid(position).trimmed();

        if (!lineData.isEmpty()) {
            // Read the column data from the rest of the line.
            QStringList columnStrings = lineData.split("\t", QString::SkipEmptyParts);
            QList<QVariant> columnData;
            for (int column = 0; column < columnStrings.count(); ++column)
                columnData << columnStrings[column];

            if (position > indentations.last()) {
                // The last child of the current parent is now the new parent
                // unless the current parent has no children.

                if (parents.last()->childCount() > 0) {
                    parents << parents.last()->child(parents.last()->childCount()-1);
                    indentations << position;
                }
            } else {
                while (position < indentations.last() && parents.count() > 0) {
                    parents.pop_back();
                    indentations.pop_back();
                }
            }

            // Append a new item to the current parent's list of children.
            parents.last()->appendChild(new S3Item(columnData, parents.last()));
        }

        ++number;
    }
}
