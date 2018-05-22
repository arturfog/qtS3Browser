#include "s3item.h"

S3Item::S3Item(const QList<QVariant> &data, S3Item *parent)
{
    m_parentItem = parent;
    m_itemData = data;
}

S3Item::~S3Item()
{
    qDeleteAll(m_childItems);
}

void S3Item::appendChild(S3Item *item)
{
    m_childItems.append(item);
}

S3Item *S3Item::child(int row)
{
    return m_childItems.value(row);
}

int S3Item::childCount() const
{
    return m_childItems.count();
}

int S3Item::row() const
{
    if (m_parentItem)
        return m_parentItem->m_childItems.indexOf(const_cast<S3Item*>(this));

    return 0;
}

int S3Item::columnCount() const
{
    return m_itemData.count();
}

QVariant S3Item::data(int column) const
{
    return m_itemData.value(column);
}

S3Item *S3Item::parentItem()
{
    return m_parentItem;
}
