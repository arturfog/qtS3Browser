#ifndef S3MODEL_H
#define S3MODEL_H

#include <QList>
#include <QVariant>
#include <QAbstractListModel>
#include <QStringList>

#include "s3client.h"

class S3Item
{
public:
    S3Item(const QString &name, const QString &path);

    QString filePath() const;
    QString fileName() const;

private:
    QString m_name;
    QString m_path;
};

class S3Model : public QAbstractListModel
{
    Q_OBJECT
public:
    enum AnimalRoles {
        NameRole = Qt::UserRole + 1,
        PathRole
    };

    Q_INVOKABLE QString getS3Path() const { return s3Path(); }
    Q_INVOKABLE void getBuckets() const { getBuckets(); }
    Q_INVOKABLE void getObjects(const QString &text) { getObjects(text.toStdString()); }

    S3Model(QObject *parent = 0);

    void addS3Item(const S3Item &animal);

    int rowCount(const QModelIndex & parent = QModelIndex()) const;

    QString s3Path() const;

    void getBuckets();

    void getObjects(const std::string &bucket);

    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

protected:
    QHash<int, QByteArray> roleNames() const;
    S3Client s3;
private:
    QList<S3Item> m_s3items;
};

#endif // S3MODEL_H
