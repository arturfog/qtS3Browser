#ifndef S3MODEL_H
#define S3MODEL_H

#include <QList>
#include <QVariant>
#include <QAbstractItemModel>

#include "s3item.h"

class S3Model : public QAbstractItemModel
{
    Q_OBJECT

public:
    explicit S3Model(const QString &data, QObject *parent = 0);
    ~S3Model();

    QVariant data(const QModelIndex &index, int role) const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    QVariant headerData(int section, Qt::Orientation orientation,
                        int role = Qt::DisplayRole) const override;
    QModelIndex index(int row, int column,
                      const QModelIndex &parent = QModelIndex()) const override;
    QModelIndex parent(const QModelIndex &index) const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;

private:
    void setupModelData(const QStringList &lines, S3Item *parent);

    S3Item *rootItem;
};

#endif // S3MODEL_H
