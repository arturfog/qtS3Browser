#ifndef S3ITEM_H
#define S3ITEM_H

#include <QList>
#include <QVariant>

class S3Item {
public:
    explicit S3Item(const QList<QVariant> &data, S3Item *parentItem = 0);
    ~S3Item();

    void appendChild(S3Item *child);

    S3Item *child(int row);
    int childCount() const;
    int columnCount() const;
    QVariant data(int column) const;
    int row() const;
    S3Item *parentItem();

private:
    QList<S3Item*> m_childItems;
    QList<QVariant> m_itemData;
    S3Item *m_parentItem;
};


#endif // S3ITEM_H
